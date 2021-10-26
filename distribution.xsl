<?xml version="1.0" encoding="UTF-8"?>





<xsl:transform
    xmlns:adms   = "http://www.w3.org/ns/adms#"
    xmlns:cnt    = "http://www.w3.org/2011/content#"
    xmlns:dc     = "http://purl.org/dc/elements/1.1/"
    xmlns:dcat   = "http://www.w3.org/ns/dcat#"
    xmlns:dct    = "http://purl.org/dc/terms/"
    xmlns:dctype = "http://purl.org/dc/dcmitype/"
    xmlns:dqv    = "http://www.w3.org/ns/dqv#"
    xmlns:earl   = "http://www.w3.org/ns/earl#"
    xmlns:foaf   = "http://xmlns.com/foaf/0.1/"
    xmlns:gco    = "http://www.isotc211.org/2005/gco"
    xmlns:geodcatap = "http://data.europa.eu/930/"
    xmlns:gmd    = "http://www.isotc211.org/2005/gmd"
    xmlns:gml    = "http://www.opengis.net/gml"
    xmlns:gmx    = "http://www.isotc211.org/2005/gmx"
    xmlns:gsp    = "http://www.opengis.net/ont/geosparql#"
    xmlns:i      = "http://inspire.ec.europa.eu/schemas/common/1.0"
    xmlns:i-gp   = "http://inspire.ec.europa.eu/schemas/geoportal/1.0"
    xmlns:locn   = "http://www.w3.org/ns/locn#"
    xmlns:owl    = "http://www.w3.org/2002/07/owl#"
    xmlns:org    = "http://www.w3.org/ns/org#"
    xmlns:prov   = "http://www.w3.org/ns/prov#"
    xmlns:rdf    = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs   = "http://www.w3.org/2000/01/rdf-schema#"
    xmlns:schema = "http://schema.org/"
    xmlns:sdmx-attribute = "http://purl.org/linked-data/sdmx/2009/attribute#"
    xmlns:skos   = "http://www.w3.org/2004/02/skos/core#"
    xmlns:srv    = "http://www.isotc211.org/2005/srv"
    xmlns:vcard  = "http://www.w3.org/2006/vcard/ns#"
    xmlns:wdrs   = "http://www.w3.org/2007/05/powder-s#"
    xmlns:xlink  = "http://www.w3.org/1999/xlink"
    xmlns:xsi    = "http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl    = "http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="earl gco gmd gml gmx i i-gp srv xlink xsi xsl wdrs"
    version="1.0">

  <xsl:output method="xml"
              indent="yes"
              encoding="utf-8"
              cdata-section-elements="locn:geometry dcat:bbox" />

<!--

  Global variables
  ================

-->

<!-- Variables $core and $extended. -->
<!--

  These variables are meant to be placeholders for the IDs used for the core and extended profiles of GeoDCAT-AP.

-->
<!--
  <xsl:variable name="core">core</xsl:variable>
  <xsl:variable name="extended">extended</xsl:variable>
  <xsl:variable name="core">http://data.europa.eu/r5r/</xsl:variable>
  <xsl:variable name="extended">http://data.europa.eu/930/</xsl:variable>
-->
  <xsl:variable name="profile-core-code">core</xsl:variable>
  <xsl:variable name="profile-extended-code">extended</xsl:variable>
  <xsl:variable name="profile-core-uri">http://data.europa.eu/r5r/</xsl:variable>
  <xsl:variable name="profile-extended-uri">http://data.europa.eu/930/</xsl:variable>

<!--

  Mapping parameters
  ==================

  This section includes mapping parameters by the XSLT processor used, or, possibly, manually.

-->

<!-- Parameter $profile -->
<!--

  This parameter specifies the GeoDCAT-AP profile to be used:
  - value "core": the GeoDCAT-AP Core profile, which includes only the INSPIRE and ISO 19115 core metadata elements supported in DCAT-AP
  - value "extended": the GeoDCAT-AP Extended profile, which defines mappings for all the INSPIRE and ISO 19115 core metadata elements

  The current specifications for the core and extended GeoDCAT-AP profiles are available on the Joinup collaboration platform:

    https://joinup.ec.europa.eu/solution/geodcat-ap

-->



<!-- Uncomment to use GeoDCAT-AP Core as default profile -->
<!--
  <xsl:variable name="default-profile" select="$profile-core-uri"/>
-->
<!-- Uncomment to use GeoDCAT-AP Extended as default profile -->
  <xsl:variable name="default-profile" select="$profile-extended-uri"/>

  <xsl:param name="profile" select="$default-profile"/>

  <xsl:variable name="selected-profile">
    <xsl:choose>
      <xsl:when test="$profile = $profile-core-code">
        <xsl:value-of select="$profile-core-uri"/>
      </xsl:when>
      <xsl:when test="$profile = $profile-core-uri">
        <xsl:value-of select="$profile"/>
      </xsl:when>
      <xsl:when test="$profile = $profile-extended-code">
        <xsl:value-of select="$profile-extended-uri"/>
      </xsl:when>
      <xsl:when test="$profile = $profile-extended-uri">
        <xsl:value-of select="$profile"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$default-profile"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="core">
    <xsl:choose>
      <xsl:when test="$profile = $profile-core-code">
        <xsl:value-of select="$profile-core-code"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$profile-core-uri"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="extended">
    <xsl:choose>
      <xsl:when test="$profile = $profile-extended-code">
        <xsl:value-of select="$profile-extended-code"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$profile-extended-uri"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

<!-- Parameter $include-deprecated -->
<!--
  This parameter specifies whether deprecated mappings must ("yes") or must not
  ("no") be included in the output.
-->

<!-- Uncomment to include deprecated mappings from the output -->

  <xsl:param name="include-deprecated">no</xsl:param>

<!-- Uncomment to exclude deprecated mappings from the output -->
<!--
  <xsl:param name="include-deprecated">no</xsl:param>
-->

<!-- Parameter $CoupledResourceLookUp -->
<!--

  This parameter specifies whether the coupled resource, referenced via @xlink:href, 
  should be looked up to fetch the resource's  unique resource identifier (i.e., code 
  and code space). More precisely:
  - value "enabled": The coupled resource is looked up
  - value "disabled": The coupled resource is not looked up

  The default value is "enabled" for GeoDCAT-AP Extended, and "disabled" otherwise.

  CAVEAT: Using this feature may cause the transformation to hang, in case the URL in 
  @xlink:href is broken, the request hangs indefinitely, or does not return the 
  expected resource (e.g., and HTML page, instead of an XML-encoded ISO 19139 record). 
  It is strongly recommended that this issue is dealt with by using appropriate 
  configuration parameters and error handling (e.g., by specifying a timeout on HTTP 
  calls and by setting the HTTP Accept header to "application/xml").

-->

  <xsl:param name="CoupledResourceLookUp">
    <xsl:choose>
      <xsl:when test="$profile = $extended">
        <xsl:text>enabled</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>disabled</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

<!--

  Other global parameters
  =======================

-->

<!-- Variables to be used to convert strings into lower/uppercase by using the translate() function. -->

  <xsl:variable name="lowercase">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="uppercase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

<!-- URIs, URNs and names for spatial reference system registers. -->

  <xsl:param name="EpsgSrsBaseUri">http://www.opengis.net/def/crs/EPSG/0</xsl:param>
  <xsl:param name="EpsgSrsBaseUrn">urn:ogc:def:crs:EPSG</xsl:param>
  <xsl:param name="EpsgSrsName">EPSG Coordinate Reference Systems</xsl:param>
  <xsl:param name="OgcSrsBaseUri">http://www.opengis.net/def/crs/OGC</xsl:param>
  <xsl:param name="OgcSrsBaseUrn">urn:ogc:def:crs:OGC</xsl:param>
  <xsl:param name="OgcSrsName">OGC Coordinate Reference Systems</xsl:param>
  <xsl:param name="catalogId"></xsl:param>

<!-- URI and URN for CRS84. -->

  <xsl:param name="Crs84Uri" select="concat($OgcSrsBaseUri,'/1.3/CRS84')"/>
  <xsl:param name="Crs84Urn" select="concat($OgcSrsBaseUrn,':1.3:CRS84')"/>

<!-- URI and URN for ETRS89. -->

  <xsl:param name="Etrs89Uri" select="concat($EpsgSrsBaseUri,'/4258')"/>
  <xsl:param name="Etrs89Urn" select="concat($EpsgSrsBaseUrn,'::4258')"/>

<!-- URI and URN of the spatial reference system (SRS) used in the bounding box.
     The default SRS is CRS84. If a different SRS is used, also parameter
     $SrsAxisOrder must be specified. -->

<!-- The SRS URI is used in the WKT and GML encodings of the bounding box. -->
  <xsl:param name="SrsUri" select="$Crs84Uri"/>
<!-- The SRS URN is used in the GeoJSON encoding of the bounding box. -->
  <xsl:param name="SrsUrn" select="$Crs84Urn"/>

<!-- Axis order for the reference SRS:
     - "LonLat": longitude / latitude
     - "LatLon": latitude / longitude.
     The axis order must be specified only if the reference SRS is different from CRS84.
     If the reference SRS is CRS84, this parameter is ignored. -->

  <xsl:param name="SrsAxisOrder">LonLat</xsl:param>

<!-- Namespaces -->

<!-- Currently not used.
  <xsl:param name="timeUri">http://placetime.com/</xsl:param>
  <xsl:param name="timeInstantUri" select="concat($timeUri,'instant/gregorian/')"/>
  <xsl:param name="timeIntervalUri" select="concat($timeUri,'interval/gregorian/')"/>
-->
  <xsl:param name="dcat">http://www.w3.org/ns/dcat#</xsl:param>
  <xsl:param name="dct">http://purl.org/dc/terms/</xsl:param>
  <xsl:param name="dctype">http://purl.org/dc/dcmitype/</xsl:param>
  <xsl:param name="foaf">http://xmlns.com/foaf/0.1/</xsl:param>
  <xsl:param name="geodcatap">http://data.europa.eu/930/</xsl:param>
  <xsl:param name="gsp">http://www.opengis.net/ont/geosparql#</xsl:param>
  <xsl:param name="prov">http://www.w3.org/ns/prov#</xsl:param>
  <xsl:param name="skos">http://www.w3.org/2004/02/skos/core#</xsl:param>
  <xsl:param name="vcard">http://www.w3.org/2006/vcard/ns#</xsl:param>
  <xsl:param name="xsd">http://www.w3.org/2001/XMLSchema#</xsl:param>

<!-- Old params used for the SRS
  <xsl:param name="ogcCrsBaseUri">http://www.opengis.net/def/EPSG/0/</xsl:param>
  <xsl:param name="ogcCrsBaseUrn">urn:ogc:def:EPSG::</xsl:param>
-->

<!-- Currently not used.
  <xsl:param name="inspire">http://inspire.ec.europa.eu/schemas/md/</xsl:param>
-->

<!-- Currently not used.
  <xsl:param name="kos">http://ec.europa.eu/open-data/kos/</xsl:param>
  <xsl:param name="kosil" select="concat($kos,'interoperability-level/')"/>
  <xsl:param name="kosdst" select="concat($kos,'dataset-type/')"/>
  <xsl:param name="kosdss" select="concat($kos,'dataset-status/Completed')"/>
  <xsl:param name="kosdoct" select="concat($kos,'documentation-type/')"/>
  <xsl:param name="koslic" select="concat($kos,'licence/EuropeanCommission')"/>
-->

<!-- OP's NALs base URI -->

  <xsl:param name="op">http://publications.europa.eu/resource/authority/</xsl:param>

<!-- OP's NALs URIs -->

  <xsl:param name="opcb" select="concat($op,'corporate-body/')"/>
  <xsl:param name="opcountry" select="concat($op,'country/')"/>
  <xsl:param name="opfq" select="concat($op,'frequency/')"/>
  <xsl:param name="opft" select="concat($op,'file-type/')"/>
  <xsl:param name="oplang" select="concat($op,'language/')"/>
  
<!-- Currently not used.
  <xsl:param name="cldFrequency">http://purl.org/cld/freq/</xsl:param>
-->

<!-- IANA base URI -->

  <xsl:param name="iana">https://www.iana.org/assignments/</xsl:param>

<!-- IANA registers URIs -->

  <xsl:param name="iana-mt" select="concat($iana,'media-types/')"/>

<!-- DEPRECATED: Parameter kept for backward compatibility with GeoDCAT-AP v1.* -->
<!-- This is used as the datatype for the GeoJSON-based encoding of the bounding box. -->
  <xsl:param name="geojsonMediaTypeUri" select="concat($iana-mt,'application/vnd.geo+json')"/>

<!-- QUDT Units Vocabulary -->
  <xsl:param name="qudt-unit">http://www.qudt.org/vocab/unit</xsl:param>

<!-- Ontology for units of measure (OM) -->
  <xsl:param name="om18">http://www.wurvoc.org/vocabularies/om-1.8</xsl:param>
  <xsl:param name="om2">http://www.ontology-of-units-of-measure.org/resource/om-2</xsl:param>
  <xsl:param name="om" select="$om18"/>

<!-- Units of measure -->
  <xsl:param name="uom-m" select="concat($qudt-unit, '/', 'M')"/>
  <xsl:param name="uom-km" select="concat($qudt-unit, '/', 'KiloM')"/>
  <xsl:param name="uom-ft" select="concat($qudt-unit, '/', 'FT')"/>
  <xsl:param name="uom-deg" select="concat($qudt-unit, '/', 'DEG')"/>
<!--
  <xsl:param name="uom-m" select="concat($om, '/', 'metre')"/>
  <xsl:param name="uom-km" select="concat($om, '/', 'kilometre')"/>
  <xsl:param name="uom-ft">
    <xsl:choose>
      <xsl:when test="$om = $om18">
        <xsl:value-of select="concat($om, '/', 'foot-international')"/>
      </xsl:when>
      <xsl:when test="$om = $om2">
        <xsl:value-of select="concat($om, '/', 'foot-International')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="uom-deg" select="concat($om, '/', 'degree')"/>
-->

<!-- INSPIRE base URI -->

  <xsl:param name="inspire">http://inspire.ec.europa.eu/</xsl:param>

<!-- INSPIRE metadata code list URIs -->

  <xsl:param name="INSPIRECodelistUri" select="concat($inspire,'metadata-codelist/')"/>
  <xsl:param name="SpatialDataServiceCategoryCodelistUri" select="concat($INSPIRECodelistUri,'SpatialDataServiceCategory')"/>
  <xsl:param name="DegreeOfConformityCodelistUri" select="concat($INSPIRECodelistUri,'DegreeOfConformity')"/>
  <xsl:param name="ResourceTypeCodelistUri" select="concat($INSPIRECodelistUri,'ResourceType')"/>
  <xsl:param name="ResponsiblePartyRoleCodelistUri" select="concat($INSPIRECodelistUri,'ResponsiblePartyRole')"/>
  <xsl:param name="SpatialDataServiceTypeCodelistUri" select="concat($INSPIRECodelistUri,'SpatialDataServiceType')"/>
  <xsl:param name="TopicCategoryCodelistUri" select="concat($INSPIRECodelistUri,'TopicCategory')"/>

<!-- INSPIRE code list URIs (not yet supported; the URI pattern is tentative) -->
<!-- DEPRECATED following the publication of the relevant code list in the INSPIRE Registry
  <xsl:param name="SpatialRepresentationTypeCodelistUri" select="concat($INSPIRECodelistUri,'SpatialRepresentationTypeCode')"/>
  <xsl:param name="MaintenanceFrequencyCodelistUri" select="concat($INSPIRECodelistUri,'MaintenanceFrequencyCode')"/>
-->
  <xsl:param name="SpatialRepresentationTypeCodelistUri" select="concat($INSPIRECodelistUri,'SpatialRepresentationType')"/>
  <xsl:param name="MaintenanceFrequencyCodelistUri" select="concat($INSPIRECodelistUri,'MaintenanceFrequency')"/>

<!-- INSPIRE glossary URI -->

  <xsl:param name="INSPIREGlossaryUri" select="concat($inspire,'glossary/')"/>

<!-- INSPIRE glossary URI -->

  <xsl:param name="inspire-mt" select="concat($inspire,'media-types/')"/>

<!--

  Master template
  ===============

-->

  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates select="gmd:MD_Metadata|//gmd:MD_Metadata"/>
    </rdf:RDF>
  </xsl:template>

<!--

  Metadata template
  =================

-->

  <xsl:template match="gmd:MD_Metadata|//gmd:MD_Metadata">



  <xsl:param name="ResourceUri">
    <xsl:variable name="rURI" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/*/gmd:code/gco:CharacterString"/>
    <xsl:if test="$rURI != '' and ( starts-with($rURI, 'http://') or starts-with($rURI, 'https://') )">
      <xsl:value-of select="$rURI"/>
    </xsl:if>
  </xsl:param>

  <xsl:param name="MetadataUri">
    <xsl:variable name="mURI" select="gmd:fileIdentifier/gco:CharacterString"/>
    <xsl:if test="$mURI != '' and ( starts-with($mURI, 'http://') or starts-with($mURI, 'https://') )">
      <xsl:value-of select="$mURI"/>
    </xsl:if>
  </xsl:param>



    <xsl:param name="ormlang">
      <xsl:choose>
        <xsl:when test="gmd:language/gmd:LanguageCode/@codeListValue != ''">
          <xsl:value-of select="translate(gmd:language/gmd:LanguageCode/@codeListValue,$uppercase,$lowercase)"/>
        </xsl:when>
        <xsl:when test="gmd:language/gmd:LanguageCode != ''">
          <xsl:value-of select="translate(gmd:language/gmd:LanguageCode,$uppercase,$lowercase)"/>
        </xsl:when>
        <xsl:when test="gmd:language/gco:CharacterString != ''">
          <xsl:value-of select="translate(gmd:language/gco:CharacterString,$uppercase,$lowercase)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:param>

    <xsl:param name="MetadataLanguage">
      <xsl:choose>
        <xsl:when test="$ormlang = 'bul'">
          <xsl:text>bg</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'cze'">
          <xsl:text>cs</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'dan'">
          <xsl:text>da</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'ger'">
          <xsl:text>de</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'gre'">
          <xsl:text>el</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'eng'">
          <xsl:text>en</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'spa'">
          <xsl:text>es</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'est'">
          <xsl:text>et</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'fin'">
          <xsl:text>fi</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'fre'">
          <xsl:text>fr</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'gle'">
          <xsl:text>ga</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'hrv'">
          <xsl:text>hr</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'ita'">
          <xsl:text>it</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'lav'">
          <xsl:text>lv</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'lit'">
          <xsl:text>lt</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'hun'">
          <xsl:text>hu</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'mlt'">
          <xsl:text>mt</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'dut'">
          <xsl:text>nl</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'pol'">
          <xsl:text>pl</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'por'">
          <xsl:text>pt</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'rum'">
          <xsl:text>ru</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'slo'">
          <xsl:text>sk</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'slv'">
          <xsl:text>sl</xsl:text>
        </xsl:when>
        <xsl:when test="$ormlang = 'swe'">
          <xsl:text>sv</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$ormlang"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <xsl:param name="orrlang">
      <xsl:choose>
        <xsl:when test="gmd:identificationInfo/*/gmd:language/gmd:LanguageCode/@codeListValue != ''">
          <xsl:value-of select="translate(gmd:identificationInfo/*/gmd:language/gmd:LanguageCode/@codeListValue,$uppercase,$lowercase)"/>
        </xsl:when>
        <xsl:when test="gmd:identificationInfo/*/gmd:language/gmd:LanguageCode != ''">
          <xsl:value-of select="translate(gmd:identificationInfo/*/gmd:language/gmd:LanguageCode,$uppercase,$lowercase)"/>
        </xsl:when>
        <xsl:when test="gmd:identificationInfo/*/gmd:language/gco:CharacterString != ''">
          <xsl:value-of select="translate(gmd:identificationInfo/*/gmd:language/gco:CharacterString,$uppercase,$lowercase)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:param>

    <xsl:param name="ResourceLanguage">
      <xsl:choose>
        <xsl:when test="$orrlang = 'bul'">
          <xsl:text>bg</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'cze'">
          <xsl:text>cs</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'dan'">
          <xsl:text>da</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'ger'">
          <xsl:text>de</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'gre'">
          <xsl:text>el</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'eng'">
          <xsl:text>en</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'spa'">
          <xsl:text>es</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'est'">
          <xsl:text>et</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'fin'">
          <xsl:text>fi</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'fre'">
          <xsl:text>fr</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'gle'">
          <xsl:text>ga</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'hrv'">
          <xsl:text>hr</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'ita'">
          <xsl:text>it</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'lav'">
          <xsl:text>lv</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'lit'">
          <xsl:text>lt</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'hun'">
          <xsl:text>hu</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'mlt'">
          <xsl:text>mt</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'dut'">
          <xsl:text>nl</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'pol'">
          <xsl:text>pl</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'por'">
          <xsl:text>pt</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'rum'">
          <xsl:text>ru</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'slo'">
          <xsl:text>sk</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'slv'">
          <xsl:text>sl</xsl:text>
        </xsl:when>
        <xsl:when test="$orrlang = 'swe'">
          <xsl:text>sv</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$orrlang"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <xsl:param name="IsoScopeCode">
      <xsl:value-of select="normalize-space(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)"/>
    </xsl:param>

    <xsl:param name="InspireResourceType">
      <xsl:if test="$IsoScopeCode = 'dataset' or $IsoScopeCode = 'series' or $IsoScopeCode = 'service'">
        <xsl:value-of select="$IsoScopeCode"/>
      </xsl:if>
    </xsl:param>

    <xsl:param name="ResourceVersion">
        <xsl:for-each select="gmd:metadataStandardVersion">
            <dct:hasVersion>
                <xsl:value-of select="normalize-space(gco:CharacterString)"/>
            </dct:hasVersion>
        </xsl:for-each>
    </xsl:param>

    <xsl:param name="ResourceType">
      <xsl:choose>
        <xsl:when test="$IsoScopeCode = 'dataset' or $IsoScopeCode = 'nonGeographicDataset'">
          <xsl:text>dataset</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$IsoScopeCode"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <dct:isPartOf rdf:resource="https://f2ds.eosc-pillar.eu/catalog/{$catalogId}"/>
    


   

    




        
<!-- Metadata language -->
      <xsl:if test="$ormlang != ''">
        <dct:language>
          <dct:LinguisticSystem rdf:about="{concat($oplang,translate($ormlang,$lowercase,$uppercase))}"/>
        </dct:language>
      </xsl:if>


 
<!-- Constraints related to access and use for services -->
<!-- Mapping moved to the core profile for compliance with DCAT-AP 2 -->
<!--
      <xsl:if test="$ResourceType = 'service' and ($ServiceType = 'discovery' or $profile = $extended)">
-->
      <xsl:if test="$ResourceType = 'service'">
        <xsl:copy-of select="$ConstraintsRelatedToAccessAndUse"/>
      </xsl:if>

<!-- Conformity -->
      <xsl:apply-templates select="gmd:dataQualityInfo/*/gmd:report/*/gmd:result/*/gmd:specification/gmd:CI_Citation">
        <xsl:with-param name="ResourceUri" select="$ResourceUri"/>
        <xsl:with-param name="MetadataLanguage" select="$MetadataLanguage"/>
        <xsl:with-param name="Conformity" select="$Conformity"/>
      </xsl:apply-templates>

<!-- Spatial representation type -->
      <xsl:variable name="SpatialRepresentationType">
        <xsl:apply-templates select="gmd:identificationInfo/*/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode"/>
      </xsl:variable>

      <xsl:for-each select="gmd:distributionInfo/gmd:MD_Distribution">
<!-- Encoding -->
        <xsl:variable name="Encoding">
          <xsl:apply-templates select="gmd:distributionFormat/gmd:MD_Format/gmd:name/*"/>
        </xsl:variable>
<!-- Resource locators (access / download URLs) -->
        <xsl:for-each select="gmd:transferOptions/*/gmd:onLine/*">

          <xsl:variable name="url" select="gmd:linkage/gmd:URL"/>

          <xsl:variable name="protocol" select="gmd:protocol/*"/>

          <xsl:variable name="protocol-url" select="gmd:protocol/gmx:Anchor/@xlink:href"/>

          <xsl:variable name="function" select="gmd:function/gmd:CI_OnLineFunctionCode/@codeListValue"/>

          <xsl:variable name="Title">
            <xsl:for-each select="gmd:name">
              <dct:title xml:lang="{$MetadataLanguage}">
                <xsl:value-of select="normalize-space(*)"/>
              </dct:title>
              <xsl:call-template name="LocalisedString">
                <xsl:with-param name="term">dct:title</xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:variable>

          <xsl:variable name="Version">
            <xsl:for-each select="gmd:version">
                <dct:hasVersion xml:lang="{$MetadataLanguage}">
                    <xsl:value-of select="normalize-space(*)"/>
                </dct:hasVersion>
                <xsl:call-template name="LocalisedString">
                <xsl:with-param name="term">dct:hasVersion</xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:variable>

          <xsl:variable name="Description">
            <xsl:for-each select="gmd:description">
              <dct:description xml:lang="{$MetadataLanguage}">
                <xsl:value-of select="normalize-space(*)"/>
              </dct:description>
              <xsl:call-template name="LocalisedString">
                <xsl:with-param name="term">dct:description</xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:variable>

          <xsl:variable name="TitleAndDescription">
<!--
            <xsl:for-each select="gmd:name/gco:CharacterString">
              <dct:title xml:lang="{$MetadataLanguage}"><xsl:value-of select="."/></dct:title>
            </xsl:for-each>
            <xsl:for-each select="gmd:description/gco:CharacterString">
              <dct:description xml:lang="{$MetadataLanguage}"><xsl:value-of select="."/></dct:description>
             </xsl:for-each>
-->
            <xsl:copy-of select="$Title"/>
            <xsl:copy-of select="$Description"/>
            <xsl:copy-of select="$Version"/>
          </xsl:variable>

          <xsl:variable name="TitleOrDescriptionOrPlaceholder">
            <xsl:choose>
              <xsl:when test="normalize-space(gmd:name/*) != ''">
                <xsl:value-of select="normalize-space(gmd:name/*)"/>
              </xsl:when>
              <xsl:when test="normalize-space(gmd:description/*) != ''">
                <xsl:value-of select="normalize-space(gmd:description)"/>
              </xsl:when>
                <xsl:when test="normalize-space(gmd:description/*) != ''">
                <xsl:value-of select="normalize-space(gmd:version)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>N/A</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:choose>
<!-- Mapping added to the core profile for compliance with DCAT-AP 2 -->
            <xsl:when test="$ResourceType = 'service'">
              <xsl:call-template name="service-endpoint">
                <xsl:with-param name="function" select="$function"/>
                <xsl:with-param name="protocol" select="$protocol"/>
                <xsl:with-param name="url" select="$url"/>
              </xsl:call-template>
              <xsl:if test="$profile = $extended">
                <xsl:call-template name="service-protocol">
                  <xsl:with-param name="function" select="$function"/>
                  <xsl:with-param name="protocol" select="$protocol"/>
                  <xsl:with-param name="url" select="$url"/>
                </xsl:call-template>
              </xsl:if>
            </xsl:when>
<!-- Distributions -->
            <xsl:when test="$ResourceType = 'dataset' or $ResourceType = 'series'">
              <xsl:variable name="points-to-service">
                <xsl:call-template name="detect-service">
                  <xsl:with-param name="function" select="$function"/>
                  <xsl:with-param name="protocol" select="$protocol"/>
                  <xsl:with-param name="url" select="$url"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="$points-to-service = 'yes' or $function = 'download' or $function = 'offlineAccess' or $function = 'order'">
                  <dcat:distribution>
                    <dcat:Distribution>
<!-- Title and description -->
                      <xsl:copy-of select="$TitleAndDescription"/>
<!-- Access URL -->
<!--
                      <xsl:for-each select="gmd:linkage/gmd:URL">
                        <dcat:accessURL rdf:resource="{.}"/>
                      </xsl:for-each>
-->
                      <xsl:choose>
                        <xsl:when test="$points-to-service = 'yes'">
                          <dcat:accessService rdf:parseType="Resource">
                            <rdf:type rdf:resource="{$dcat}DataService"/>
                            <dct:title xml:lang="{$MetadataLanguage}">
                              <xsl:value-of select="$TitleOrDescriptionOrPlaceholder"/>
                            </dct:title>
                            <xsl:call-template name="service-endpoint">
                              <xsl:with-param name="function" select="$function"/>
                              <xsl:with-param name="protocol" select="$protocol"/>
                              <xsl:with-param name="url" select="$url"/>
                            </xsl:call-template>
                            <xsl:if test="$profile = $extended">
                              <xsl:call-template name="service-protocol">
                                <xsl:with-param name="function" select="$function"/>
                                <xsl:with-param name="protocol" select="$protocol"/>
                                <xsl:with-param name="url" select="$url"/>
                              </xsl:call-template>
                            </xsl:if>
                          </dcat:accessService>
                        </xsl:when>
                        <xsl:otherwise>
                        </xsl:otherwise>
                      </xsl:choose>
                      <dcat:accessURL rdf:resource="{$url}"/>
<!-- Constraints related to access and use -->
                      <xsl:copy-of select="$ConstraintsRelatedToAccessAndUse"/>
<!-- Spatial representation type (tentative) -->
                      <xsl:if test="$profile = $extended">
                        <xsl:copy-of select="$SpatialRepresentationType"/>
                      </xsl:if>
<!-- Encoding -->
                      <xsl:copy-of select="$Encoding"/>
<!-- Resource character encoding -->
                      <xsl:if test="$profile = $extended">
                        <xsl:copy-of select="$ResourceCharacterEncoding"/>
                      </xsl:if>
                    </dcat:Distribution>
                  </dcat:distribution>
                </xsl:when>
                <xsl:when test="$function = 'information' or $function = 'search'">
<!-- ?? Should foaf:page be detailed with title, description, etc.? -->
                  <xsl:for-each select="gmd:linkage/gmd:URL">
                    <foaf:page>
                      <foaf:Document rdf:about="{.}">
                        <xsl:copy-of select="$TitleAndDescription"/>
                      </foaf:Document>
                    </foaf:page>
                  </xsl:for-each>
                </xsl:when>
              </xsl:choose>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>
</xsl:template>









<!-- Character encoding -->

  <xsl:template name="CharacterEncoding" match="gmd:characterSet/gmd:MD_CharacterSetCode">
    <xsl:variable name="CharSetCode">
      <xsl:choose>
        <xsl:when test="@codeListValue = 'ucs2'">
          <xsl:text>ISO-10646-UCS-2</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = 'ucs4'">
          <xsl:text>ISO-10646-UCS-4</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = 'utf7'">
          <xsl:text>UTF-7</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = 'utf8'">
          <xsl:text>UTF-8</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = 'utf16'">
          <xsl:text>UTF-16</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part1'">
          <xsl:text>ISO-8859-1</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part2'">
          <xsl:text>ISO-8859-2</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part3'">
          <xsl:text>ISO-8859-3</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part4'">
          <xsl:text>ISO-8859-4</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part5'">
          <xsl:text>ISO-8859-5</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part6'">
          <xsl:text>ISO-8859-6</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part7'">
          <xsl:text>ISO-8859-7</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part8'">
          <xsl:text>ISO-8859-8</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part9'">
          <xsl:text>ISO-8859-9</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part10'">
          <xsl:text>ISO-8859-10</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part11'">
          <xsl:text>ISO-8859-11</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part12'">
          <xsl:text>ISO-8859-12</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part13'">
          <xsl:text>ISO-8859-13</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part14'">
          <xsl:text>ISO-8859-14</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part15'">
          <xsl:text>ISO-8859-15</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part16'">
          <xsl:text>ISO-8859-16</xsl:text>
        </xsl:when>
<!-- Mapping to be verified: multiple candidates are available in the IANA register for jis -->
        <xsl:when test="@codeListValue = 'jis'">
          <xsl:text>JIS_Encoding</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = 'shiftJIS'">
          <xsl:text>Shift_JIS</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = 'eucJP'">
          <xsl:text>EUC-JP</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = 'usAscii'">
          <xsl:text>US-ASCII</xsl:text>
        </xsl:when>
<!-- Mapping to be verified: multiple candidates are available in the IANA register ebcdic  -->
        <xsl:when test="@codeListValue = 'ebcdic'">
          <xsl:text>IBM037</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = 'eucKR'">
          <xsl:text>EUC-KR</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = 'big5'">
          <xsl:text>Big5</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = 'GB2312'">
          <xsl:text>GB2312</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <cnt:characterEncoding rdf:datatype="{$xsd}string"><xsl:value-of select="$CharSetCode"/></cnt:characterEncoding>
<!--
    <cnt:characterEncoding rdf:datatype="{$xsd}string"><xsl:value-of select="@codeListValue"/></cnt:characterEncoding>
-->
  </xsl:template>

<!-- Encoding -->

  <xsl:template name="Encoding" match="gmd:distributionFormat/gmd:MD_Format/gmd:name/*">
    <xsl:param name="format-label">
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:param>
    <xsl:param name="format-uri">
      <xsl:choose>
        <xsl:when test="@xlink:href and @xlink:href != ''">
          <xsl:value-of select="@xlink:href"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="EncodingLabelToUri">
            <xsl:with-param name="label" select="normalize-space(.)"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="media-type">
      <xsl:choose>
        <xsl:when test="$format-uri != ''">
          <dct:MediaType rdf:about="{$format-uri}"/>
        </xsl:when>
        <xsl:when test="$format-label != ''">
          <dct:MediaType>
            <rdfs:label><xsl:value-of select="$format-label"/></rdfs:label>
          </dct:MediaType>
        </xsl:when>
      </xsl:choose>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="starts-with($format-uri,$iana-mt)">
        <dcat:mediaType>
          <xsl:copy-of select="$media-type"/>
        </dcat:mediaType>
      </xsl:when>
      <xsl:otherwise>
        <dct:format>
          <xsl:copy-of select="$media-type"/>
        </dct:format>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

<!-- Encoding: Label to URI -->

<!-- CAVEAT: This template attempts to map textual description
     of a distribution encoding, based on the most frequently
     used labels from the European Data Portal. -->

  <xsl:template name="EncodingLabelToUri">
    <xsl:param name="label"/>
    <xsl:param name="norm-label">
      <xsl:choose>
        <xsl:when test="starts-with(normalize-space($label),$opft)">
          <xsl:value-of select="translate(substring-after(normalize-space($label),$opft),$uppercase,$lowercase)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="translate(normalize-space($label),$uppercase,$lowercase)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="$norm-label = 'aaigrid'">
        <xsl:value-of select="concat($opft,'GRID_ASCII')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'aig'">
        <xsl:value-of select="concat($opft,'GRID')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'atom'">
        <xsl:value-of select="concat($opft,'ATOM')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'csv'">
        <xsl:value-of select="concat($opft,'CSV')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'csw'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'XML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'dbf'">
        <xsl:value-of select="concat($opft,'DBF')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'dgn'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'BIN')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'djvu'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($iana-mt,'image/vn.djvu')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'doc'">
        <xsl:value-of select="concat($opft,'DOC')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'docx'">
        <xsl:value-of select="concat($opft,'DOCX')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'dxf'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($iana-mt,'image/vn.dxf')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'dwg'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($iana-mt,'image/vn.dwg')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'ecw'">
        <xsl:value-of select="concat($opft,'ECW')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'ecwp'">
        <xsl:value-of select="concat($opft,'ECW')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'elp'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'EXE')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'epub'">
        <xsl:value-of select="concat($opft,'EPUB')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'fgeo'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'GDB')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'gdb'">
        <xsl:value-of select="concat($opft,'GDB')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'geojson'">
        <xsl:value-of select="concat($opft,'GEOJSON')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'geopackage'">
        <xsl:value-of select="concat($opft,'GPKG')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'georss'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'RSS')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'geotiff'">
        <xsl:value-of select="concat($opft,'TIFF')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'gif'">
        <xsl:value-of select="concat($opft,'GIF')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'gml'">
        <xsl:value-of select="concat($opft,'GML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'gmz'">
        <xsl:value-of select="concat($opft,'GMZ')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'gpkg'">
        <xsl:value-of select="concat($opft,'GPKG')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'gpx'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'XML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'grid'">
        <xsl:value-of select="concat($opft,'GRID')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'grid_ascii'">
        <xsl:value-of select="concat($opft,'GRID_ASCII')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'gtfs'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'CSV')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'gtiff'">
        <xsl:value-of select="concat($opft,'TIFF')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'gzip'">
        <xsl:value-of select="concat($opft,'GZIP')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'html'">
        <xsl:value-of select="concat($opft,'HTML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'jpeg'">
        <xsl:value-of select="concat($opft,'JPEG')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'jpg'">
        <xsl:value-of select="concat($opft,'JPEG')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'json'">
        <xsl:value-of select="concat($opft,'JSON')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'json-ld'">
        <xsl:value-of select="concat($opft,'JSON_LD')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'json_ld'">
        <xsl:value-of select="concat($opft,'JSON_LD')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'jsonld'">
        <xsl:value-of select="concat($opft,'JSON_LD')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'kml'">
        <xsl:value-of select="concat($opft,'KML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'kmz'">
        <xsl:value-of select="concat($opft,'KMZ')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'las'">
        <xsl:value-of select="concat($opft,'LAS')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'laz'">
        <xsl:value-of select="concat($opft,'LAZ')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'marc'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($iana-mt,'application/marc')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'mdb'">
        <xsl:value-of select="concat($opft,'MDB')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'mxd'">
        <xsl:value-of select="concat($opft,'MXD')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'n-triples'">
        <xsl:value-of select="concat($opft,'RDF_N_TRIPLES')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'n3'">
        <xsl:value-of select="concat($opft,'N3')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'netcdf'">
        <xsl:value-of select="concat($opft,'NETCDF')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'ods'">
        <xsl:value-of select="concat($opft,'ODS')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'odt'">
        <xsl:value-of select="concat($opft,'ODT')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'ogc:csw'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'XML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'ogc:sos'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'XML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'ogc:wcs'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'TIFF')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'ogc:wfs'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'GML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'ogc:wfs-g'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'GML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'ogc:wmc'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'XML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'ogc:wms'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'PNG')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'ogc:wmts'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'PNG')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'ogc:wps'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'GML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'oracledump'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($inspire-mt,'application/x-oracledump')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'pc-axis'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'TXT')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'pdf'">
        <xsl:value-of select="concat($opft,'PDF')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'pgeo'">
        <xsl:value-of select="concat($opft,'MDB')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'png'">
        <xsl:value-of select="concat($opft,'PNG')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'rar'">
        <xsl:value-of select="concat($opft,'RAR')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'rdf/xml'">
        <xsl:value-of select="concat($opft,'RDF_XML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'rdf-n3'">
        <xsl:value-of select="concat($opft,'N3')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'rdf-turtle'">
        <xsl:value-of select="concat($opft,'RDF_TURTLE')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'rdf-xml'">
        <xsl:value-of select="concat($opft,'RDF_XML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'rdf_n_triples'">
        <xsl:value-of select="concat($opft,'RDF_N_TRIPLES')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'rdf_n3'">
        <xsl:value-of select="concat($opft,'N3')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'rdf_turtle'">
        <xsl:value-of select="concat($opft,'RDF_TURTLE')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'rdf_xml'">
        <xsl:value-of select="concat($opft,'RDF_XML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'rss'">
        <xsl:value-of select="concat($opft,'RSS')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'rtf'">
        <xsl:value-of select="concat($opft,'RTF')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'scorm'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'ZIP')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'shp'">
        <xsl:value-of select="concat($opft,'SHP')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'sos'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'XML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'spatialite'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($iana-mt,'application/vnd.sqlite3')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'sqlite'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($iana-mt,'application/vnd.sqlite3')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'sqlite3'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($iana-mt,'application/vnd.sqlite3')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'svg'">
        <xsl:value-of select="concat($opft,'SVG')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'text'">
        <xsl:value-of select="concat($opft,'TXT')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'tiff'">
        <xsl:value-of select="concat($opft,'TIFF')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'tmx'">
        <xsl:value-of select="concat($opft,'TMX')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'tsv'">
        <xsl:value-of select="concat($opft,'TSV')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'ttl'">
        <xsl:value-of select="concat($opft,'RDF_TURTLE')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'turtle'">
        <xsl:value-of select="concat($opft,'RDF_TURTLE')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'txt'">
        <xsl:value-of select="concat($opft,'TXT')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'vcard-json'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'JSON')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'vcard-xml'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'XML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'xbrl'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'XML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'xhtml'">
        <xsl:value-of select="concat($opft,'XHTML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'xls'">
        <xsl:value-of select="concat($opft,'XLS')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'xlsx'">
        <xsl:value-of select="concat($opft,'XLSX')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'xml'">
        <xsl:value-of select="concat($opft,'XML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'wcs'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'TIFF')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'wfs'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'GML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'wfs-g'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'GML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'wmc'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'XML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'wms'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'PNG')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'wmts'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'PNG')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'wps'">
<!-- PROVISIONAL -->
        <xsl:value-of select="concat($opft,'GML')"/>
      </xsl:when>
      <xsl:when test="$norm-label = 'zip'">
        <xsl:value-of select="concat($opft,'ZIP')"/>
      </xsl:when>
      <xsl:otherwise>
<!--
        <xsl:value-of select="concat($opft,'OP_DATPRO')"/>
-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- Maintenance information -->

  <xsl:template name="MaintenanceInformation" match="gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode">
<!-- The following parameter maps frequency codes used in ISO 19139 metadata to the corresponding ones of the Dublin Core Collection Description Frequency Vocabulary (when available). -->
    <xsl:param name="FrequencyCodeURI">
      <xsl:if test="@codeListValue != ''">
        <xsl:choose>
          <xsl:when test="@codeListValue = 'continual'">
<!--  DC Freq voc
             <xsl:value-of select="concat($cldFrequency,'continuous')"/>
-->
            <xsl:value-of select="concat($opfq,'CONT')"/>
          </xsl:when>
          <xsl:when test="@codeListValue = 'daily'">
<!--  DC Freq voc
            <xsl:value-of select="concat($cldFrequency,'daily')"/>
-->
            <xsl:value-of select="concat($opfq,'DAILY')"/>
          </xsl:when>
          <xsl:when test="@codeListValue = 'weekly'">
<!--  DC Freq voc
            <xsl:value-of select="concat($cldFrequency,'weekly')"/>
-->
            <xsl:value-of select="concat($opfq,'WEEKLY')"/>
          </xsl:when>
          <xsl:when test="@codeListValue = 'fortnightly'">
<!--  DC Freq voc
            <xsl:value-of select="concat($cldFrequency,'biweekly')"/>
-->
            <xsl:value-of select="concat($opfq,'BIWEEKLY')"/>
          </xsl:when>
          <xsl:when test="@codeListValue = 'monthly'">
<!--  DC Freq voc
            <xsl:value-of select="concat($cldFrequency,'monthly')"/>
-->
            <xsl:value-of select="concat($opfq,'MONTHLY')"/>
          </xsl:when>
          <xsl:when test="@codeListValue = 'quarterly'">
<!--  DC Freq voc
            <xsl:value-of select="concat($cldFrequency,'quarterly')"/>
-->
            <xsl:value-of select="concat($opfq,'QUARTERLY')"/>
          </xsl:when>
          <xsl:when test="@codeListValue = 'biannually'">
<!--  DC Freq voc
            <xsl:value-of select="concat($cldFrequency,'semiannual')"/>
-->
            <xsl:value-of select="concat($opfq,'ANNUAL_2')"/>
          </xsl:when>
          <xsl:when test="@codeListValue = 'annually'">
<!--  DC Freq voc
            <xsl:value-of select="concat($cldFrequency,'annual')"/>
-->
            <xsl:value-of select="concat($opfq,'ANNUAL')"/>
          </xsl:when>
          <xsl:when test="@codeListValue = 'asNeeded'">
<!--  A mapping is missing in Dublin Core -->
<!--  A mapping is missing in MDR Freq NAL -->
            <xsl:value-of select="concat($MaintenanceFrequencyCodelistUri,'/',@codeListValue)"/>
          </xsl:when>
          <xsl:when test="@codeListValue = 'irregular'">
<!--  DC Freq voc
            <xsl:value-of select="concat($cldFrequency,'irregular')"/>
-->
            <xsl:value-of select="concat($opfq,'IRREG')"/>
          </xsl:when>
          <xsl:when test="@codeListValue = 'notPlanned'">
<!--  A mapping is missing in Dublin Core -->
<!--  A mapping is missing in MDR Freq NAL -->
            <xsl:value-of select="concat($MaintenanceFrequencyCodelistUri,'/',@codeListValue)"/>
          </xsl:when>
          <xsl:when test="@codeListValue = 'unknown'">
<!--  A mapping is missing in Dublin Core -->
<!--  INSPIRE Freq code list (not yet available)
            <xsl:value-of select="concat($MaintenanceFrequencyCodelistUri,'/',@codeListValue)"/>
-->
            <xsl:value-of select="concat($opfq,'UNKNOWN')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </xsl:param>
    <xsl:if test="$FrequencyCodeURI != ''">
      <dct:accrualPeriodicity>
        <dct:Frequency rdf:about="{$FrequencyCodeURI}"/>
      </dct:accrualPeriodicity>
    </xsl:if>
  </xsl:template>

<!-- Coordinate and temporal reference system (tentative) -->

  <xsl:template name="ReferenceSystem" match="gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier">
    <xsl:param name="MetadataLanguage"/>
    <xsl:param name="code" select="gmd:code/*[self::gco:CharacterString|gmx:Anchor]"/>
    <xsl:param name="link" select="gmd:code/gmx:Anchor/@xlink:href"/>
    <xsl:param name="codespace" select="gmd:codeSpace/*[self::gco:CharacterString|gmx:Anchor]"/>
    <xsl:param name="version" select="gmd:version/*[self::gco:CharacterString|gmx:Anchor]"/>
    <xsl:param name="version-statement">
      <xsl:if test="$profile = $extended">
      <xsl:if test="$version != ''">
        <owl:versionInfo xml:lang="{$MetadataLanguage}"><xsl:value-of select="$version"/></owl:versionInfo>
      </xsl:if>
      </xsl:if>
    </xsl:param>

    <xsl:choose>
      <xsl:when test="starts-with($link, 'http://') or starts-with($link, 'https://')">
        <dct:conformsTo rdf:resource="{$link}"/>
          
      </xsl:when>
      <xsl:when test="starts-with($code, 'http://') or starts-with($code, 'https://')">
        <dct:conformsTo rdf:resource="{$code}"/>
      </xsl:when>
      <xsl:when test="starts-with($code, 'urn:')">
        <xsl:variable name="srid">
          <xsl:if test="starts-with(translate($code,$uppercase,$lowercase), translate($EpsgSrsBaseUrn,$uppercase,$lowercase))">
            <xsl:value-of select="substring-after(substring-after(substring-after(substring-after(substring-after(substring-after($code,':'),':'),':'),':'),':'),':')"/>
          </xsl:if>
        </xsl:variable>
        <xsl:variable name="sridVersion" select="substring-before(substring-after(substring-after(substring-after(substring-after(substring-after($code,':'),':'),':'),':'),':'),':')"/>
        <xsl:choose>
          <xsl:when test="$srid != '' and string(number($srid)) != 'NaN'">
            <dct:conformsTo rdf:resource="{$EpsgSrsBaseUri}/{$srid}"/>
              
          </xsl:when>
          <xsl:otherwise>
            <dct:conformsTo rdf:resource="{$INSPIREGlossaryUri}SpatialReferenceSystem"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$code = number($code) and (translate($codespace,$uppercase,$lowercase) = 'epsg' or starts-with(translate($codespace,$uppercase,$lowercase),translate($EpsgSrsBaseUrn,$uppercase,$lowercase)))">
            <dct:conformsTo rdf:resource="{$EpsgSrsBaseUri}/{$code}"/>
          </xsl:when>
          <xsl:when test="translate(normalize-space(translate($code,$uppercase,$lowercase)),': ','') = 'etrs89'">
            <dct:conformsTo rdf:resource="{$Etrs89Uri}"/>
          </xsl:when>
          <xsl:when test="translate(normalize-space(translate($code,$uppercase,$lowercase)),': ','') = 'crs84'">
           <dct:conformsTo rdf:resource="{$Crs84Uri}"/>
          </xsl:when>
          <xsl:otherwise>
            <dct:conformsTo rdf:resource="{$INSPIREGlossaryUri}SpatialReferenceSystem"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- Spatial representation type (tentative) -->

  <xsl:template name="SpatialRepresentationType" match="gmd:identificationInfo/*/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode">
    <adms:representationTechnique rdf:resource="{$SpatialRepresentationTypeCodelistUri}/{@codeListValue}"/>
  </xsl:template>


  <xsl:template name="Alpha3-to-Alpha2">
    <xsl:param name="lang"/>
    <xsl:choose>
      <xsl:when test="$lang = 'bul'">
        <xsl:text>bg</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'cze'">
        <xsl:text>cs</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'dan'">
        <xsl:text>da</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'ger'">
        <xsl:text>de</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'gre'">
        <xsl:text>el</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'eng'">
        <xsl:text>en</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'spa'">
        <xsl:text>es</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'est'">
        <xsl:text>et</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'fin'">
        <xsl:text>fi</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'fre'">
        <xsl:text>fr</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'gle'">
        <xsl:text>ga</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'hrv'">
        <xsl:text>hr</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'ita'">
        <xsl:text>it</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'lav'">
        <xsl:text>lv</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'lit'">
        <xsl:text>lt</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'hun'">
        <xsl:text>hu</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'mlt'">
        <xsl:text>mt</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'dut'">
        <xsl:text>nl</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'pol'">
        <xsl:text>pl</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'por'">
        <xsl:text>pt</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'rum'">
        <xsl:text>ru</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'slo'">
        <xsl:text>sk</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'slv'">
        <xsl:text>sl</xsl:text>
      </xsl:when>
      <xsl:when test="$lang = 'swe'">
        <xsl:text>sv</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$lang"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- Templates for services and distributions pointing to services -->

  <xsl:template name="detect-service">
    <xsl:param name="function"/>
    <xsl:param name="protocol"/>
    <xsl:param name="url"/>
    <xsl:choose>
      <xsl:when test="contains(substring-after(translate($url, $uppercase, $lowercase), '?'), 'request=getcapabilities')">
        <xsl:text>yes</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>no</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="service-protocol-code">
    <xsl:param name="function"/>
    <xsl:param name="protocol"/>
    <xsl:param name="url"/>
    <xsl:choose>
      <xsl:when test="contains(substring-after(translate($url, $uppercase, $lowercase), '?'), 'service=csw')">
        <xsl:text>csw</xsl:text>
      </xsl:when>
      <xsl:when test="translate($protocol, $uppercase, $lowercase) = 'ogc:csw'">
        <xsl:text>csw</xsl:text>
      </xsl:when>
      <xsl:when test="contains(substring-after(translate($url, $uppercase, $lowercase), '?'), 'service=sos')">
        <xsl:text>sos</xsl:text>
      </xsl:when>
      <xsl:when test="translate($protocol, $uppercase, $lowercase) = 'ogc:sos'">
        <xsl:text>sos</xsl:text>
      </xsl:when>
      <xsl:when test="contains(substring-after(translate($url, $uppercase, $lowercase), '?'), 'service=sps')">
        <xsl:text>sps</xsl:text>
      </xsl:when>
      <xsl:when test="translate($protocol, $uppercase, $lowercase) = 'ogc:sps'">
        <xsl:text>sps</xsl:text>
      </xsl:when>
      <xsl:when test="contains(substring-after(translate($url, $uppercase, $lowercase), '?'), 'service=wcs')">
        <xsl:text>wcs</xsl:text>
      </xsl:when>
      <xsl:when test="translate($protocol, $uppercase, $lowercase) = 'ogc:wcs'">
        <xsl:text>wcs</xsl:text>
      </xsl:when>
      <xsl:when test="contains(substring-after(translate($url, $uppercase, $lowercase), '?'), 'service=wfs')">
        <xsl:text>wfs</xsl:text>
      </xsl:when>
      <xsl:when test="translate($protocol, $uppercase, $lowercase) = 'ogc:wfs'">
        <xsl:text>wfs</xsl:text>
      </xsl:when>
      <xsl:when test="contains(substring-after(translate($url, $uppercase, $lowercase), '?'), 'service=wms')">
        <xsl:text>wms</xsl:text>
      </xsl:when>
      <xsl:when test="translate($protocol, $uppercase, $lowercase) = 'ogc:wms'">
        <xsl:text>wms</xsl:text>
      </xsl:when>
      <xsl:when test="contains(substring-after(translate($url, $uppercase, $lowercase), '?'), 'service=wmts')">
        <xsl:text>wmts</xsl:text>
      </xsl:when>
      <xsl:when test="translate($protocol, $uppercase, $lowercase) = 'ogc:wmts'">
        <xsl:text>wmts</xsl:text>
      </xsl:when>
      <xsl:when test="contains(substring-after(translate($url, $uppercase, $lowercase), '?'), 'service=wps')">
        <xsl:text>wps</xsl:text>
      </xsl:when>
      <xsl:when test="translate($protocol, $uppercase, $lowercase) = 'ogc:wps'">
        <xsl:text>wps</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="service-protocol-url">
    <xsl:param name="protocol"/>
    <xsl:choose>
      <xsl:when test="$protocol = 'csw'">
        <xsl:text>http://www.opengeospatial.org/standards/cat</xsl:text>
      </xsl:when>
      <xsl:when test="$protocol = 'sos'">
        <xsl:text>http://www.opengeospatial.org/standards/sos</xsl:text>
      </xsl:when>
      <xsl:when test="$protocol = 'sps'">
        <xsl:text>http://www.opengeospatial.org/standards/sps</xsl:text>
      </xsl:when>
      <xsl:when test="$protocol = 'wcs'">
        <xsl:text>http://www.opengeospatial.org/standards/wcs</xsl:text>
      </xsl:when>
      <xsl:when test="$protocol = 'wfs'">
        <xsl:text>http://www.opengeospatial.org/standards/wfs</xsl:text>
      </xsl:when>
      <xsl:when test="$protocol = 'wms'">
        <xsl:text>http://www.opengeospatial.org/standards/wms</xsl:text>
      </xsl:when>
      <xsl:when test="$protocol = 'wmts'">
        <xsl:text>http://www.opengeospatial.org/standards/wmts</xsl:text>
      </xsl:when>
      <xsl:when test="$protocol = 'wps'">
        <xsl:text>http://www.opengeospatial.org/standards/wps</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="service-protocol">
    <xsl:param name="function"/>
    <xsl:param name="protocol"/>
    <xsl:param name="url"/>
    <xsl:param name="protocol-url">
      <xsl:call-template name="service-protocol-url">
        <xsl:with-param name="protocol">
          <xsl:call-template name="service-protocol-code">
            <xsl:with-param name="function" select="$function"/>
            <xsl:with-param name="protocol" select="$protocol"/>
            <xsl:with-param name="url" select="$url"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:param>
    <xsl:if test="$protocol-url != ''">
       <dct:conformsTo rdf:resource="{$protocol-url}"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="service-endpoint">
    <xsl:param name="function"/>
    <xsl:param name="protocol"/>
    <xsl:param name="url"/>
    <xsl:param name="endpoint-url">
      <xsl:choose>
        <xsl:when test="contains($url, '?')">
          <xsl:value-of select="substring-before($url, '?')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$url"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="endpoint-description">
      <xsl:choose>
        <xsl:when test="contains(substring-after(translate($url, $uppercase, $lowercase), '?'), 'request=getcapabilities')">
          <xsl:value-of select="$url"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$url"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="service-type">
    </xsl:param>
    <xsl:if test="$endpoint-url != ''">
      <dcat:endpointURL rdf:resource="{$endpoint-url}"/>
    </xsl:if>
    <xsl:if test="$endpoint-description != ''">
      <dcat:endpointDescription rdf:resource="{$endpoint-description}"/>
    </xsl:if>
  </xsl:template>

</xsl:transform>
