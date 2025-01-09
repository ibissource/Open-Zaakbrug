<xsl:stylesheet exclude-result-prefixes="#all" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:zgw="http://www.wearefrank.nl/zgw" xmlns:StUF="http://www.egem.nl/StUF/StUF0301" xmlns:ZKN="http://www.egem.nl/StUF/sector/zkn/0310" xmlns:BG="http://www.egem.nl/StUF/sector/bg/0310" version="2.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />
    <xsl:param name="ZgwZaak"/>
    <xsl:param name="Resultaat"/>
    <xsl:param name="ResultaatType"/>
    <xsl:param name="ExtraElementen" as="node()?"><StUF:extraElementen/></xsl:param>

    <xsl:function name="zgw:convertZdsDateToZgwDate" as="xs:string">
        <xsl:param name="dateStr" as="xs:string"/>
        <xsl:value-of select="concat(substring($dateStr,1,4), substring($dateStr,6,2), substring($dateStr,9,2))"/>
	</xsl:function>

    <xsl:function name="zgw:convertZgwBooleanToZdsBoolean" as="xs:string">
    	<xsl:param name="zgwBoolean" as="xs:string"/>
		<xsl:choose>
      		<xsl:when test="lower-case($zgwBoolean)='true'">J</xsl:when>
            <xsl:when test="lower-case($zgwBoolean)='false'">N</xsl:when>
      		<xsl:otherwise>invalid character</xsl:otherwise>
    	</xsl:choose>
	</xsl:function>

    <xsl:function name="zgw:convertZgwBetalingsIndicatieToZdsBetalingsIndicatie">
        <xsl:param name="zdsBetalingsIndicatie"/>
		<xsl:choose>
            <xsl:when test="lower-case($zdsBetalingsIndicatie)='nvt'">N.v.t.</xsl:when>
            <xsl:when test="lower-case($zdsBetalingsIndicatie)='nog_niet'">(Nog) niet</xsl:when>
            <xsl:when test="lower-case($zdsBetalingsIndicatie)='gedeeltelijk'">Gedeeltelijk</xsl:when>
            <xsl:when test="lower-case($zdsBetalingsIndicatie)='geheel'">Geheel</xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template match="/">
        <ZKN:object StUF:entiteittype="ZAK">
            <xsl:if test="$ZgwZaak/ZgwZaak/identificatie != ''">
                <ZKN:identificatie><xsl:value-of select="$ZgwZaak/ZgwZaak/identificatie" /></ZKN:identificatie>
            </xsl:if>
            <xsl:if test="$ZgwZaak/ZgwZaak/omschrijving != ''">
                <ZKN:omschrijving><xsl:value-of select="$ZgwZaak/ZgwZaak/omschrijving" /></ZKN:omschrijving>
            </xsl:if>
            <xsl:if test="$ZgwZaak/ZgwZaak/toelichting != ''">
                <ZKN:toelichting><xsl:value-of select="$ZgwZaak/ZgwZaak/toelichting" /></ZKN:toelichting>
            </xsl:if>
            <xsl:apply-templates select="$ZgwZaak/ZgwZaak/kenmerken" />
            <!-- anderZaakObject -->
            <xsl:if test="$Resultaat/root/toelichting != ''">
                <ZKN:resultaat>
                    <ZKN:omschrijving>
                        <xsl:value-of select="$ResultaatType/ZgwRolType/omschrijving" />
                    </ZKN:omschrijving>
                    <ZKN:toelichting>
                        <xsl:value-of select="$Resultaat/root/toelichting" />
                    </ZKN:toelichting>
                </ZKN:resultaat>            </xsl:if>
            <xsl:if test="$ZgwZaak/ZgwZaak/startdatum != ''">
                <ZKN:startdatum><xsl:value-of select="zgw:convertZdsDateToZgwDate($ZgwZaak/ZgwZaak/startdatum)" /></ZKN:startdatum>
            </xsl:if>
            <xsl:if test="$ZgwZaak/ZgwZaak/registratiedatum != ''">
            <ZKN:registratiedatum><xsl:value-of select="zgw:convertZdsDateToZgwDate($ZgwZaak/ZgwZaak/registratiedatum)" /></ZKN:registratiedatum>
            </xsl:if>
            <xsl:if test="$ZgwZaak/ZgwZaak/publicatiedatum != ''">
                <ZKN:publicatiedatum><xsl:value-of select="zgw:convertZdsDateToZgwDate($ZgwZaak/ZgwZaak/publicatiedatum)" /></ZKN:publicatiedatum> <!-- convert -->
            </xsl:if>
            <xsl:if test="$ZgwZaak/ZgwZaak/einddatumGepland != ''">
                <ZKN:einddatumGepland><xsl:value-of select="zgw:convertZdsDateToZgwDate($ZgwZaak/ZgwZaak/einddatumGepland)" /></ZKN:einddatumGepland> <!-- convert -->
            </xsl:if>
            <xsl:if test="$ZgwZaak/ZgwZaak/uiterlijkeEinddatumAfdoening != ''">
                <ZKN:uiterlijkeEinddatum><xsl:value-of select="zgw:convertZdsDateToZgwDate($ZgwZaak/ZgwZaak/uiterlijkeEinddatumAfdoening)" /></ZKN:uiterlijkeEinddatum> <!-- convert -->
            </xsl:if>
            <xsl:if test="$ZgwZaak/ZgwZaak/einddatum != ''">
                <ZKN:einddatum><xsl:value-of select="zgw:convertZdsDateToZgwDate($ZgwZaak/ZgwZaak/einddatum)" /></ZKN:einddatum> <!-- convert -->
            </xsl:if>
            <xsl:apply-templates select="$ZgwZaak/ZgwZaak/opschorting" />
            <xsl:apply-templates select="$ZgwZaak/ZgwZaak/verlenging" />
            <xsl:if test="$ZgwZaak/ZgwZaak/betalingsindicatie != ''">
                <ZKN:betalingsIndicatie><xsl:value-of select="zgw:convertZgwBetalingsIndicatieToZdsBetalingsIndicatie($ZgwZaak/ZgwZaak/betalingsindicatie)" /></ZKN:betalingsIndicatie>
            </xsl:if>
            <xsl:if test="$ZgwZaak/ZgwZaak/laatsteBetaaldatum != ''">
                <ZKN:laatsteBetaaldatum><xsl:value-of select="$ZgwZaak/ZgwZaak/laatsteBetaaldatum" /></ZKN:laatsteBetaaldatum> <!-- convert -->
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$ZgwZaak/ZgwZaak/archiefnominatie = 'vernietigen'">
                    <ZKN:archiefnominatie>J</ZKN:archiefnominatie>
                </xsl:when>
                <xsl:otherwise>
                    <ZKN:archiefnominatie>N</ZKN:archiefnominatie>
                    </xsl:otherwise>
            </xsl:choose>
            <!-- datumVernietigingDossier -->
            <!-- <zaakniveau>1</zaakniveau> -->
            <!-- <deelzakenIndicatie>N</deelzakenIndicatie> -->
            <xsl:if test="string-length($ExtraElementen) gt 0"><xsl:copy-of select="$ExtraElementen" copy-namespaces="false" /></xsl:if>
        </ZKN:object>
    </xsl:template>

    <xsl:template match="verlenging">
        <xsl:if test="string-length(.) gt 0 and duur != '0'">
            <ZKN:verlenging>
                <ZKN:duur><xsl:value-of select="replace(replace(replace(replace(duur, 'D', ''), 'M', ''), 'Y', ''), 'P', '')" /></ZKN:duur>
                <ZKN:reden>
                    <xsl:value-of select="reden" />
                    <xsl:if test="reden = ''">
                        <xsl:attribute name="xsi:nil" select="'true'" />
                        <xsl:attribute name="StUF:noValue" select="'geenWaarde'" />
                    </xsl:if>
                </ZKN:reden>
            </ZKN:verlenging>
        </xsl:if>
    </xsl:template>
    <xsl:template match="opschorting">
        <xsl:if test="string-length(.) gt 0">
            <ZKN:opschorting>
                <ZKN:indicatie><xsl:value-of select="zgw:convertZgwBooleanToZdsBoolean(indicatie)" /></ZKN:indicatie>
                <ZKN:reden>
                    <xsl:value-of select="reden" />
                    <xsl:if test="reden = ''">
                        <xsl:attribute name="xsi:nil" select="'true'" />
                        <xsl:attribute name="StUF:noValue" select="'geenWaarde'" />
                    </xsl:if>
                </ZKN:reden>
            </ZKN:opschorting>
        </xsl:if>
    </xsl:template>
    <xsl:template match="kenmerken">
        <xsl:if test="string-length(.) gt 0">
            <ZKN:kenmerk>
                <ZKN:kenmerk>
                    <xsl:value-of select="kenmerk" />
                    <xsl:if test="kenmerk = ''">
                        <xsl:attribute name="xsi:nil" select="'true'" />
                        <xsl:attribute name="StUF:noValue" select="'geenWaarde'" />
                    </xsl:if>
                </ZKN:kenmerk>
                <ZKN:bron>
                    <xsl:value-of select="bron" />
                    <xsl:if test="bron = ''">
                        <xsl:attribute name="xsi:nil" select="'true'" />
                        <xsl:attribute name="StUF:noValue" select="'geenWaarde'" />
                    </xsl:if>
                </ZKN:bron>
            </ZKN:kenmerk>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>