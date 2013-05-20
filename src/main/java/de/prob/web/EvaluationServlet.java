package de.prob.web;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.common.base.Strings;
import com.google.gson.Gson;
import com.google.inject.Inject;
import com.google.inject.Singleton;

import de.be4.classicalb.core.parser.exceptions.BParseException;
import de.tla2b.exceptions.TLA2BException;
import de.tla2b.translation.ExpressionTranslator;

@SuppressWarnings("serial")
@Singleton
public class EvaluationServlet extends HttpServlet {

	private final static Logger logger = LoggerFactory
			.getLogger(EvaluationServlet.class);

	private final EvaluatorPool pool;

	@Inject
	public EvaluationServlet(EvaluatorPool pool) {
		this.pool = pool;
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res)
			throws ServletException, IOException {
		PrintWriter out = res.getWriter();
		String mode = req.getParameter("mode");
		String formalism = req.getParameter("formalism");
		String input = req.getParameter("input");
		logger.trace("FORMALISM " + formalism);
		logger.trace("INPUT " + input);

		String formula = "tla".equals(formalism) ? translateFromTla(input, out) : input;

		if (formula == null)
			return;
		else
			evaluateB(out, mode, formula);
	}

	private void evaluateB(PrintWriter out, String mode, String formula) {
		logger.trace("FORMULA " + formula);

		Evaluator evaluator = pool.get();
		ResultObject result = new ResultObject();
		logger.trace("Evaluating '{}'", formula);
		try {
			if (!"tautology".equals(mode))
				result.setOutput(evaluator.eval(formula));
			else
				result.setOutput(evaluator.check(formula));
		} catch (BParseException e) {
			result.setOutput(produceErrorMessage(e, formula));
			result.setHighlight(e.getToken().getLine());
		} finally {
			Gson g = new Gson();
			out.println(g.toJson(result));
			out.close();
		}
	}

	private String translateFromTla(String input, PrintWriter out) {
		try {
			return ExpressionTranslator.translateExpression(input);
		} catch (TLA2BException e) {
			ResultObject result = new ResultObject();
			result.setOutput(e.getLocalizedMessage());
			Gson g = new Gson();
			out.println(g.toJson(result));
			out.close();
			return null;
		}
	}

	private String produceErrorMessage(BParseException cause, String formula) {
		int line = cause.getToken().getLine();
		int pos = cause.getToken().getPos();
		pos = (line == 1) ? pos - 10 : pos; // remove #FORMULA
		return "PARSE ERROR at line " + line + " column " + pos + "\n\n"
				+ peeloff(formula, line) + "\n" + Strings.repeat(" ", pos)
				+ "^" + "\n\n" + cause.getRealMsg();
	}

	private String peeloff(String formula, int line) {
		String[] split = (formula + " ").split("\n");
		return split[line - 1];
	}
}