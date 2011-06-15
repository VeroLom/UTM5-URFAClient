<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink">

	<xsl:output
		method="html"
		encoding="utf-8"
		indent="yes"
		doctype-public = "-//W3C//DTD HTML 4.01 Transitional//EN"
		doctype-system = "http://www.w3.org/TR/html4/loose.dtd" />

	<xsl:template match="/">
		<html>
			<head>
				<title>UTM5 API Functions</title>
			</head>
			<body>
				<h1>UTM5 API Functions</h1>

				<xsl:apply-templates select="urfa/function" />
			</body>
		</html>
	</xsl:template>

	<xsl:template match="function">
		<p class="name"><xsl:value-of select="@name" /> (<xsl:value-of select="@id" />)</p>
	</xsl:template>

</xsl:stylesheet>
