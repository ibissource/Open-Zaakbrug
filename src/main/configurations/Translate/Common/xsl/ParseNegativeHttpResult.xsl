<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    <xsl:param name="senderPipeName" select="''" as="xs:string" />

    <xsl:template match="/">
        <error>
            <xsl:choose>
                <xsl:when test="root/status=400">
                    <code>TranslationError</code>
                    <reason><xsl:value-of select="$senderPipeName" /> received 400 Bad Request from ZGW API</reason>
                </xsl:when>
                <xsl:when test="root/status=401">
                    <code>TechnicalError</code>
                    <reason><xsl:value-of select="$senderPipeName" /> received 401 Unauthorized from ZGW API</reason>
                </xsl:when>
                <xsl:when test="root/status=403">
                    <code>TechnicalError</code>
                    <reason><xsl:value-of select="$senderPipeName" /> received 403 Forbidden from ZGW API</reason>
                </xsl:when>
                <xsl:when test="root/status=404">
                    <code>TechnicalError</code>
                    <reason><xsl:value-of select="$senderPipeName" /> received 404 Not Found from ZGW API</reason>
                </xsl:when>
                <xsl:when test="root/status=500">
                    <code>TechnicalError</code>
                    <reason><xsl:value-of select="$senderPipeName" /> received 500 Internal Server Error from ZGW API</reason>
                </xsl:when>
                <xsl:otherwise>
                    <code>TechnicalError</code>
                    <reason><xsl:value-of select="$senderPipeName" /> received some negative response from ZGW API</reason>
                </xsl:otherwise>
            </xsl:choose>
            <details>
                <xsl:value-of select="concat(/root/code, ' ', /root/title, ' ', /root/status, ' ', /root/detail)" />
            </details>
            <detailsXml>
                <xsl:copy-of select="."/>
            </detailsXml>
        </error>
    </xsl:template>
</xsl:stylesheet>
