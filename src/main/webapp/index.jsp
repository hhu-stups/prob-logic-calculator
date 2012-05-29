

<!DOCTYPE html>
<!--[if lt IE 7 ]><html class="ie ie6" lang="en"> <![endif]-->
<!--[if IE 7 ]><html class="ie ie7" lang="en"> <![endif]-->
<!--[if IE 8 ]><html class="ie ie8" lang="en"> <![endif]-->
<!--[if (gte IE 9)|!(IE)]><!-->
<html lang="en">
<!--<![endif]-->
<head>
<!-- Basic Page Needs
    ================================================== -->
<meta charset="utf-8">
<title>ProB Logic calculator</title>
<meta name="description" content="">
<meta name="author" content="Jens Bendisposto">

<!-- Mobile Specific Metas
    ================================================== -->
<meta name="viewport"
	content="width=device-width, initial-scale=1, maximum-scale=1">

<!-- CSS
    ================================================== -->
<link rel="stylesheet" href="css/stylesheets_<%= de.prob.web.TimeStamp.TIME %>/base.css">
<link rel="stylesheet" href="css/stylesheets_<%= de.prob.web.TimeStamp.TIME %>/skeleton.css">
<link rel="stylesheet" href="css/stylesheets_<%= de.prob.web.TimeStamp.TIME %>/layout.css">
<link rel="stylesheet" href="css/stylesheets_<%= de.prob.web.TimeStamp.TIME %>/evalb.css">
<link rel="stylesheet" href="css/stylesheets_<%= de.prob.web.TimeStamp.TIME %>/codemirror.css">
<link rel="stylesheet" href="css/stylesheets_<%= de.prob.web.TimeStamp.TIME %>/themes/red.css">
<link rel="stylesheet" href="css/stylesheets_<%= de.prob.web.TimeStamp.TIME %>/themes/green.css">

<script type="text/x-mathjax-config">
  MathJax.Hub.Config({tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}});
</script>

<!--[if lt IE 9]>
          <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
      <![endif]-->

<!-- Favicons
      ================================================== -->
<link rel="shortcut icon" href="images/favicon.ico">
<link rel="apple-touch-icon" href="images/apple-touch-icon.png">
<link rel="apple-touch-icon" sizes="72x72"
	href="images/apple-touch-icon-72x72.png">
<link rel="apple-touch-icon" sizes="114x114"
	href="images/apple-touch-icon-114x114.png">
</head>
<body onLoad="initialize()">

	<!-- Primary Page Layout
      ================================================== -->

	<!-- Delete everything in this .container and get started on your own site! -->

	<div class="container">
		<h1 class="capital remove-bottom" style="margin-top: 40px">ProB</h1>
		<h2>Logic Calculator</h2>
		<hr />
		<div class="two-thirds column">
			<textarea name="input" id="input" rows="15" onkeyup="probeval()"></textarea>
		</div>
		<div class="one-third column omega" style="vertical-align: text-top;">
			<h3>Quantification Mode</h3>
			<select size="1" id="mode" name="mode" class="styled-select"
				onchange="probeval()">
				<option value="" selected="selected">Existential (Solving)</option>
				<option value="tautology">Universal (Checking)</option>
			</select>
			<h3>Formalism</h3>
			<select size="1" id="formalism" name="formalism"
				class="styled-select" onchange="switch_formalism()">
				<option value="classicalb" selected="selected">B Method</option>
				<option value="tla">TLA+</option>
			</select>
			<h3>Examples</h3>
			<select size="1" id="examples" name="examples" class="styled-select"
				onchange="load_example()">
				<option value="" selected="selected" />
			</select>
		</div>

		<div class="two-thirds column">
			<textarea name="output" id="output" cols="80" rows="5"></textarea>
		</div>


		<div class="sixteen columns">
			<hr style="margin-top: 20px;" />
			<h3>About the ProB Logic Calculator</h3>
			<p>
				This is an online calculator for logic formulas. It can evaluate
				predicates and formulas given in the B notation. Under the hood, we
				use the <a href="http://www.stups.uni-duesseldorf.de/ProB/">ProB</a>
				animator and model checker. The above calculator has a time-out of
				2.5 seconds, and
				<tt>MAXINT</tt>
				is set to 127 and
				<tt>MININT</tt>
				to -128. An alternative version of the calculator is available at
				the <a
					href="http://www.formalmind.com/en/blog/prob-logic-calculator">
					Formal Mind website</a>. You can also <a
					href="http://www.stups.uni-duesseldorf.de/ProB/index.php5/Download">download
					ProB</a> for execution on your computer, along with support for <a
					href="http://en.wikipedia.org/wiki/B"> B</a>, <a
					href="http://www.event-b.org/"> Event-B</a>, <a
					href="http://en.wikipedia.org/wiki/Communicating_sequential_processes">
					CSP-M</a>, <a
					href="http://research.microsoft.com/en-us/um/people/lamport/tla/tla.html">
					TLA+</a>, and <a href="http://en.wikipedia.org/wiki/Z_notation"> Z</a>.
				There are also 64-bit versions available for Linux and Mac (the
				above calculator only uses the 32-bit version).
			</p>
		</div>

		<div id="syntax"></div>

		<div class="sixteen columns">
			<hr style="margin-top: 20px;" />
			<h3>Troubleshooting</h3>
			<p>
				If you face any problem please submit a report to our <a
					href="http://jira.cobra.cs.uni-duesseldorf.de/">bug tracking
					system</a>. 
			</p>
		</div>
		<div class="sixteen columns space">
			<hr style="margin-top: 0px; margin-bottom: 0px;" />
			<div id="footer-logo">
				(C) 2012, <a href="http://www.stups.uni-duesseldorf.de">STUPS
					Group</a>, HHU Duesseldorf
			</div>
			<div class="version"><%=de.prob.web.VersionInfo.getVersion()%></div>
		</div>

		<div id="selectioneval"
			style="display: none; position: absolute; border: 1px solid #999999; background-color: #FFFFEE; padding: 4px;"></div>


	</div>
	<!-- container -->

	<!-- JS
      ================================================== -->
	<!-- <script src="http://code.jquery.com/jquery-1.7.1.min.js"></script> -->
	<script src="js/javascripts_<%= de.prob.web.TimeStamp.TIME %>/tabs.js"></script>
	<script src="js/javascripts_<%= de.prob.web.TimeStamp.TIME %>/jquery-1.7.2.min.js"></script>
	<script src="js/javascripts_<%= de.prob.web.TimeStamp.TIME %>/codemirror.js"></script>
	<script src="js/javascripts_<%= de.prob.web.TimeStamp.TIME %>/hover.js"></script>
	<script src="js/javascripts_<%= de.prob.web.TimeStamp.TIME %>/examples.js"></script>
	<script src="js/javascripts_<%= de.prob.web.TimeStamp.TIME %>/prob.js"></script>
	<script type="text/javascript"
		src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>


	<!-- End Document
  ================================================== -->
</body>
</html>