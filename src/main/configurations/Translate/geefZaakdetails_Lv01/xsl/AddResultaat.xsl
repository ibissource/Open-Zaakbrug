<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ZKN="http://www.egem.nl/StUF/sector/zkn/0310">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />
    <xsl:param name="Resultaat" />

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ZKN:startdatum">
        <ZKN:resultaat>
            <ZKN:omschrijving>
                <xsl:value-of select="$Resultaat/root/toelichting" />
            </ZKN:omschrijving>
        </ZKN:resultaat>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>