<?xml version="1.0" encoding="UTF-8"?>
<!--  
    $LastChangedDate$
    Version: 2.5 (note, this version number is only changed when there are changes to the TDS that have affect this transform).
    Dependent OPT to TDS transform revision: 839
    $Revision$
    Date last revised: 26/08/2013
    Author: Ocean Informatics Pty Ltd  -->

<!-- GENERIC MAP FROM ANY TEMPLATE DATA DOCUMENT TO OPENEHR INSTANCE -->
<!-- To Do: - implement ITEM_TABLE structures -->

<!-- ** CHANGE HISTORY **
    im: 26/06/13  - Added support for default denominator of 100 where DV_PROPRTION type is percentage
    sb: 26/08/13  - Added support for ENTRY.feeder_audit.
    sb: 17/07/13 - Added support for name attribute in INSTRUCTION > Activities node to conform with new simplified TDS format.
    sb: 15/07/13 - Added ENTRY.provider mapping (was not implemented previously).
                 - Fixed bug in POINT_EVENT and INTERVAL_EVENT event name value handling.
                 - Assigned unique name to multiple instances by adding an auto-incremented number (supported in new simplified TDS version for now).
    sb: 09/07/13 - Support observation event name attribute (as per simplified TDD format).
    sb: 09/07/13 - Support simplified TDD (locatable name as attributes, etc). Tested with NT Antenatal TDD Sample XML instances.
    sb: 05/07/13 - Fixed bug in 'PARTY_PROXY' xsl template where it assumes that there is an xsi:type attribute - it shouldn't assume this as it is an abstract type.
    sb: 24/06/13 - In progress: Support simplified TDD (locatable name as attributes, etc).
    hkf: 13/05/11 - Resolve normal_range and other_reference_ranges not being translated
    hkf: 22/03/11 - output archetype_details for all archetyped objects, support feeder_audit on COMPOSITION and workflow_id on ENTRYs
    lmt: 16/03/10 - Added xsl:when for DV_IDENTIFIER in the ELEMENT xsl:choose. Also added xsl:attribute for xsi:type to DV_IDENTIFIER call template
    sb:19/08/09:  - Added missing call-template to 'mappings' in call-template 'DV_TEXT'.
    sb:13/08/09:  - Now checks to see if 'origin.value' is not empty, if it is, then output origin with 'xsi:nil='true'' attribute (to support current the openEhrV1 deserializer expected origin), otherwise output origin with value.
    hkf:17/07/09: - EHR-957: Updated TDD_to_openEHR to resolve composer identities and context end_time and location values
    sb:10/06/09:  - Fixed bug in ISM_TRANSITION (the XML elements weren't being created for transition and careflow_step).
    sb:27/05/09:  - Fixed bug in ACTION.description (apply-templates select xpath needs to check if it is 'protocol' or not).
                           - Added 'external_ref' elements for PARTY_PROXY.
    sb:25/05/09:  - Fixed 'mappings' so that 'purpose' is optional as per RM spec.
    sb:08/05/09:  - Fixed bug in width and math_function introduced by the EHR-923 CR.
    sb: 07/05/09: - Refactoring.
    sb: 04/05/09: - EHR-923: Ensure TDD to openEHR transform is agnostic to source TDS namespace.
    sb: 06/04/09: - EHR-896: Implemented DV_INTERVAL call template and this template is now called within the 'ELEMENT' template match.
                           - Fixed various template match ELEMENT datatypes that had a 'currNode' parameter which is not required.
    sb: 20/03/09: - EHR-862: Added call template to DV_PROPORTION in xsl template match on 'ELEMENT' and the xsl template for DV_PROPORTION.
                           - Added call templates to DV_MULTIMEDIA, DV_EHR_URI, DV_URI and DV_PARSABLE in xsl template match on 'ELEMENT' as well.
    cm:17/03/09: - EHR-859: changes made (ln 158) to only create context element when TDD has context, not rely on composition.category.
    sb: 03/03/09: - EHR-837: Added support for mappings for element names and DV_ORDINAL.symbol (which is a DV_CODED_TEXT) 
                           - Removed two XSL template matches on 'tdd:name' as these do not seem to get used anywhere because 'TEXT' XSL call
                           template is being used for this purpose.
                           - Removed container 'description' xml element from ACTION and ACTIVITY, so it now aligns with the TDO (as agreed with HF).
                           - Allow zero children or empty 'protocol' structure to be outputted in the openEHR instance.
    sb: 25/02/09: -  [EHR-800 (and related TMP-957, TMP-961)] added support for 'mappings'.
    sb: 13/11/08: - Updates to reflect latest dependent OPT to TDS transform revision: 839 - including:
                           - added 'activities' and 'description' to xpaths in INSTRUCTION and ACTIVITY.
    sb: 13/11/08: - fixed incorrect logic in DV_INTERVAL xsl match template for lower/upper_included and lower/upper_unbounded values.
                           - fixed DV_INTERVAL xsl match template to support both 'oe' and 'tdd' namespaced values. 
    sb: 12/11/08: - fixed DV_QUANTITY XSL Call template to get 'oe'-prefixed as well as 'tdd'-prefixed items.
                           - fixed PARTY_IDENTIFIED XSL Call template to get 'oe'-prefixed as well as 'tdd'-prefixed items.
    sb: 28/08/08: - math_function and width attributes now come after data and state (wrong order previously) 
    sb: 27/08/08:  - Added more call-templates in 'ASSUMED_ELEMENT' template and also null_flavour check here as well.
                           - Added xpath in DV_DURATION call template for TDS-constrained duration (i.e. using 'tdd:' prefix) 
                           - Added INTERVAL_EVENT checking and now outputs math_function and width attributes for this type of EVENT. 
                           - OBSERVATION state and EVENT state structures if they exist in the TDD are now outputted.
    sb: 25/08/08: added null_flavour and other datatype call-templates when 'valueType' attribute value is necessary
    sb: 14/08/08: - fixed [ELEMENT].value xpath (to cater for '[unit_name]_value' xml element names, etc) 
    sb: 13/08/08: - added DV_QUANTITY call-template for TDS constrained quantity elements & changed order of precision and units 
                           - fixed HISTORY.origin xpath
    sb: 18-06-08 - Changed xmlns:tdd="http://schemas.oceanehr.com/templates/" to xmlns:tdd="http://schemas.oceanehr.com/templates" 
                            - resolved PARTY_IDENTIFED.name not populated due to using tdd namespace prefix rather than oe 
    sb: 18-06-08 - Removed 'if' statement on if element.value exists because null valued elements are no longer outputted 
                           - Fixed DV_INTERVAL xpath (requires tdd: prefix) and handling of lower/upper_unbounded.
    sb: 23-05-08 - Fixed 'composer' bug (was not outputting in openEHR instance & spacing on 'territory'(CODE_PHRASE call template).
    sb: 14/05/08 [MCA-38] - Added condition checks on upper/lower limits in normal range and other ranges if they exist otherwise assumed it is unbounded.
    sb 17/03/08 [EHR-533] - added xsl:template match="*[@*='oe:DV_TEXT']".
                           - added xsl:template name="DV_ORDINAL" and call to this template if TDD 'ELEMENT.valueType' attribute value is DV_ORDINAL.
    sb 13/03/08 [EHR-533] - removed xsi:type="ELEMENT" for ITEM_SINGLE (this is assumed from RM schema) - now calls ASSUMED_ELEMENT xsl template.
    sb 06/03/08 [EHR-533] - removed 'oe:' prefix from 'lower' and 'upper' xml elements in DV_INTERVAL, and COMPOSITION.
                           - removed 'archetype_details' when there is no 'template_id' attribute present.
    sb 05/03/08 [TMP-461] - added 'when' xsl statements to support DV_TEXT and DV_CODED_TEXT element values that use different prefixes 'oe:' and 'tdd:' at various levels in the
                           x-path due to changes made in the TDS (see TMP-461).
    sb 26/02/08 - [EHR-533] - added new call-template CODED_TEXT_RM_ATTRIBUTE (removed xsi:type on 'category' and 'setting' (this is assumed from the openEHR schema).
                           - removed xsi:type="HISTORY" from observation.data (as this is already assumed from the openehr schema.
                           - removed xsi:type="ELEMENT" for ITEM_LIST (this is assumed from RM schema) - now calls ASSUMED_ELEMENT xsl template.
                           - removed xsi:type="ACTIVITY" for <activities> node (again, this can be assumed from RM schema).
    sb 21/02/08 - [MCA-25] add condition on value element if have element with value only otherwise there is no element value (the latter is because of HL7 msg having a "" (overwrite
                            value with no value...or 'null'???)).
    sb: 11/02/08 - added xpath CODED_TEXT xsl template
    sb: 05/02/08 - updated archetype_details template condition.  
                           - get type of value from the "valueType" attribute of the ELEMENT element in the TDD specifying the base type specified in the schema. When this is substituted with 
                           an inherited type such as DV_CODED_TEXT the valueType will still be DV_TEXT while the xsi:type attribute on the value itself will indicated which subtype has been used.
                           [ This change is due to the CR in TMP-383 ] 
    sb: 01/02/08 - changed apply templates for archetype_details to call-template to support 'template_id' TDD attribute.
                           - removed 'oe:' prefix for (TDD) 'type' match from templates.
    sb: 15/01/08 - implemented DV_ORDERED (abstract openEHR class) template - this includes conditions for DV_QUANTIFIED, DV_AMOUNT and DV_ABSOLUTE_QUANTITY abstract
                          sub-type class attributes.
                           - fixed apply-templates select xpath where there it is within a for-each selecting nodes with 'type'
    sb: 10/01/08 - fixed ACTIVITY template so that it is a call-template rather than apply-templates because it is always of type 'ACTIVITY' by the RM (similar to observation data or type
                           'history', etc)    
    sb: 09/01/08 - implemented ITEM_SINGLE structure
                           - fixed DV_BOOLEAN - removed duplicate value element
                           - fixed DV_COUNT to now have correct type
                           - fixed composition->context->health_care_facility and participations
                           - implemented PARTY_IDENTIFIED and PARTICIPATION templates
    sb: 08/01/08 - added PARTY_PROXY call-template (to be tested)
                           - fixed 'composer' in composition
                           - fixed 'subject'
                           - fixed 'value' of ELEMENT
                           - fixed 'other_context' of composition
                           - tested 'links' attribute in LOCATABLE - works ok (tested with Problem Diagnosis)
    sb: 07/01/08 - implemented 'links' attribute from LOCATABLE class - need to test this works ok.    
    sb: 19/12/07 The following were modified to make Microbiology work:
                            - modified select to tdd:value[...] from tdd:* as this is ambigious and returns both name and value as nodesets!
                            - removed 'items' element in ADMIN_ENTRY template.
                            - added test in <ITEM_STRUCTURE> template to see if it has a 'name' element otherwise it is a 'data' or 'protocol' (or some other element collapsed in TDD) 
                            which has no 'name' element in TDD
                            - fixed select statement in SECTION template to ensure the correct nodeset is selected which is children of SECTION except for 'name' element and added 
                            back 'items' element
                            - added back 'other_context'
                            - fixed select statement in ELEMENT template to handle choice datatypes in TDD - e.g. <QUANTITY_value>.
    sb: 17/12/07 - added archetype_details; 
                            - fixed SECTION template by removing 'items' in for-each 
                            - fixed name output for ADMIN_ENTRY
                            - fixed 'other_context'
-->

<!-- *************** NOTES **************** -->
<!-- openehr rm_version is currently hardcoded as '1.0.1' - see archetype_details call-template -->
<!-- ****************************************** -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.openehr.org/v1" 
    xmlns:oe="http://schemas.openehr.org/v1" version="2.0" exclude-result-prefixes="oe">

    <!-- matches extract root element -->
    <xsl:template match="/">
        <xsl:apply-templates select="*[@type]"/>
    </xsl:template>

    <xsl:template match="*[@type='COMPOSITION']">
        <composition>
            <!--xsi:schemaLocation="http://schemas.openehr.org/v1 Composition.xsd"-->
            <xsl:attribute name="xsi:type">COMPOSITION</xsl:attribute>
            <xsl:attribute name="archetype_node_id">
                <xsl:value-of select="@archetype_node_id"/>
            </xsl:attribute>
            
            <xsl:call-template name="generate-name-any-links-and-any-archetype-details">
                <xsl:with-param name="currNode" select="."/>
            </xsl:call-template>
            
            <xsl:choose>
                <xsl:when test="@tdsVersion='3.0'">
            <language>
                        <terminology_id>
                            <value>ISO_639-1</value>
                        </terminology_id>
                        <code_string><xsl:value-of select="@language"/></code_string>
                    </language>
                    <territory>
                        <terminology_id>
                            <value>ISO_3166-1</value>
                        </terminology_id>
                        <code_string><xsl:value-of select="@territory"/></code_string>
                    </territory>
                    <category>
                        <value><xsl:value-of select="@category"/></value>
                        <defining_code>
                            <terminology_id>
                                <value>openehr</value>
                            </terminology_id>
                            <code_string>
                                <xsl:choose>
                                    <xsl:when test="@category='event'">433</xsl:when>
                                    <xsl:when test="@category='persistent'">431</xsl:when>
                                </xsl:choose>
                            </code_string>
                        </defining_code>
                    </category>
                </xsl:when>
                <xsl:otherwise>
                    <language>
                <xsl:call-template name="CODE_PHRASE">
                    <xsl:with-param name="currNode" select="*[local-name()='language']"/>
                </xsl:call-template>
            </language>
            <territory>
                <xsl:call-template name="CODE_PHRASE">
                    <xsl:with-param name="currNode" select="*[local-name()='territory']"/>
                </xsl:call-template>
            </territory>
            <category>
                <!-- [EHR-533] sb: modified call-template name 25/02/08 -->
                <xsl:call-template name="CODED_TEXT_RM_ATTRIBUTE">
                    <xsl:with-param name="currNode" select="*[local-name()='category']"/>
                </xsl:call-template>
            </category>
                </xsl:otherwise>
            </xsl:choose>
            
            <composer>
                <xsl:call-template name="PARTY_PROXY">
                    <xsl:with-param name="currNode" select="*[local-name()='composer']"/>
                </xsl:call-template>
            </composer>
            <!-- CM: 17/03/09 only when TDD has context, generte context element -->
            <!--<xsl:if test="tdd:category/tdd:defining_code/tdd:code_string!=431">-->
            <xsl:if test="*[local-name()='context']">
                <context>
                    <start_time>
                        <xsl:call-template name="DATE_TIME">
                            <xsl:with-param name="currNode" select="*[local-name()='context']/*[local-name()='start_time']"/>
                        </xsl:call-template>
                    </start_time>
                    <xsl:if test="*[local-name()='context']/*[local-name()='end_time']">
                        <end_time>
                            <xsl:call-template name="DATE_TIME">
                                <xsl:with-param name="currNode" select="*[local-name()='context']/*[local-name()='end_time']"/>
                            </xsl:call-template>
                        </end_time>
                    </xsl:if>
                    <xsl:if test="*[local-name()='context']/*[local-name()='location']">
                        <location>
                            <xsl:value-of select="*[local-name()='context']/*[local-name()='location']"/>
<!--                            <xsl:call-template name="DATE_TIME">
                                <xsl:with-param name="currNode" select="*[local-name()='context']/*[local-name()='location']"/>
                            </xsl:call-template>
-->                        </location>
                    </xsl:if>
                    <setting>
                        <!-- [EHR-533] sb: modified call-template name 25/02/08 -->
                        <xsl:call-template name="CODED_TEXT_RM_ATTRIBUTE">
                            <xsl:with-param name="currNode" select="*[local-name()='context']/*[local-name()='setting']"/>
                        </xsl:call-template>
                    </setting>
                    <xsl:if test="*[local-name()='context' and @other_context_node_id]">
                        <other_context>
                            <xsl:attribute name="xsi:type">
                                <xsl:value-of select="*[local-name()='context']/@other_context_type"/>
                            </xsl:attribute>
                            <xsl:attribute name="archetype_node_id">
                                <xsl:value-of select="*[local-name()='context']/@other_context_node_id"/>
                            </xsl:attribute>
                            <name>
                                <value>other context</value>
                            </name>
                            <!-- sb: modified 08/01/08 to get siblings of tdd:context with a 'templated' type which now belongs within other_context node. -->
                            <xsl:choose>
                                <xsl:when test="*[local-name()='context' and contains(@other_context_type, 'ITEM_SINGLE')]">
                                    <item>
                                        <xsl:call-template name="ASSUMED_ELEMENT">
                                            <xsl:with-param name="currNode" select="*[local-name()='context']/*[@type]"/>
                                        </xsl:call-template>
                                    </item>
                                </xsl:when>
                                <!-- TO DO: ITEM_TABLE -->
                                <xsl:otherwise>
                                    <xsl:for-each select="*[local-name()='context']/*[@type]">
                                        <items>
                                            <xsl:apply-templates select=".">
                                                <xsl:with-param name="currNode" select="."/>
                                            </xsl:apply-templates>
                                        </items>
                                    </xsl:for-each>        
                                </xsl:otherwise>
                            </xsl:choose>
                        </other_context>
                    </xsl:if>
                    <xsl:if test="*[local-name()='context']/*[local-name()='health_care_facility']">
                        <health_care_facility>
                            <xsl:call-template name="PARTY_IDENTIFIED">
                                <xsl:with-param name="fixedType">true</xsl:with-param><!-- e.g. for items whose type is already constrained in the RM (i.e. is fixed and assumed) -->
                                <xsl:with-param name="currNode" select="*[local-name()='context']/*[local-name()='health_care_facility']"/>
                            </xsl:call-template>
                        </health_care_facility>
                    </xsl:if>
                    <!--<xsl:if test="*[local-name()='context']/*[local-name()='participations']">-->
                        <xsl:for-each select="*[local-name()='context']/*[local-name()='participations']">
                        <participations>
                        <xsl:call-template name="PARTICIPATION">
                            <!--<xsl:with-param name="currNode" select="*[local-name()='context']/*[local-name()='participations']"/>-->
                            <xsl:with-param name="currNode" select="."/>
                        </xsl:call-template>
                        </participations>
                        </xsl:for-each>
                    <!--</xsl:if>-->
                </context>
            </xsl:if>
            
            <xsl:for-each select="*[@archetype_node_id]">
                <content>
                    <xsl:apply-templates select=".">
                        <xsl:with-param name="currNode" select="."/>
                    </xsl:apply-templates>
                </content>
            </xsl:for-each>

        </composition>
    </xsl:template>
    
    <xsl:template match="*[local-name()='links']">
        <links>
            <meaning>
                <value>
                    <xsl:value-of select="*[local-name()='meaning']/*[local-name()='value']/text()"/>
                </value>
            </meaning>
            <type>
                <value>
                    <xsl:value-of select="*[local-name()='type']/*[local-name()='value']/text()"/>
                </value>
            </type>
            <target>
                <value>
                    <xsl:value-of select="*[local-name()='target']/*[local-name()='value']/text()"/>
                </value>
            </target>
        </links>
    </xsl:template>
    
    <xsl:template match="*[local-name()='feeder_audit']">
        <feeder_audit>
            <xsl:for-each select="oe:originating_system_item_ids">
                <originating_system_item_ids>
                    <xsl:call-template name="DV_IDENTIFIER">
                        <xsl:with-param name="fixedType">true</xsl:with-param>
                    </xsl:call-template>
                </originating_system_item_ids>
            </xsl:for-each>
            <xsl:for-each select="oe:feeder_system_item_ids">
                <feeder_system_item_ids>
                    <xsl:call-template name="DV_IDENTIFIER" >
                        <xsl:with-param name="fixedType">true</xsl:with-param>
                    </xsl:call-template>
                </feeder_system_item_ids>
            </xsl:for-each>
            <xsl:for-each select="oe:original_content">
            <original_content>
                <xsl:apply-templates select="."/>
            </original_content>
            </xsl:for-each>
            <originating_system_audit>
            <xsl:call-template name="FEEDER_AUDIT_DETAILS">
                <xsl:with-param name="node" select="oe:originating_system_audit"/>
            </xsl:call-template>
            </originating_system_audit>
            <xsl:if test="oe:feeder_system_audit">
                <feeder_system_audit>
                <xsl:call-template name="FEEDER_AUDIT_DETAILS">
                    <xsl:with-param name="node" select="oe:feeder_system_audit"/>
                </xsl:call-template>
                </feeder_system_audit>
            </xsl:if>
        </feeder_audit>
    </xsl:template>
    
    <xsl:template name="FEEDER_AUDIT_DETAILS">
        <xsl:param name="node"/>
        <system_id>
            <xsl:value-of select="$node/oe:system_id"/>
        </system_id>
        <xsl:for-each select="$node/oe:location">
            <location>
            <xsl:call-template name="PARTY_IDENTIFIED">
                <xsl:with-param name="currNode" select="."/>
                <xsl:with-param name="fixedType">true</xsl:with-param>
            </xsl:call-template>
            </location>
        </xsl:for-each>
        <xsl:for-each select="$node/oe:provider">
            <provider>
            <xsl:call-template name="PARTY_IDENTIFIED">
                <xsl:with-param name="currNode" select="."/>
                <xsl:with-param name="fixedType">true</xsl:with-param>
            </xsl:call-template>
            </provider>
        </xsl:for-each>
        <xsl:for-each select="$node/oe:subject">
            <subject>
            <xsl:apply-templates select="."/>
            </subject>
        </xsl:for-each>
        <xsl:for-each select="$node/oe:time">
            <time>
            <xsl:call-template name="DATE_TIME">
                <xsl:with-param name="currNode" select="."/>                
            </xsl:call-template>
            </time>
        </xsl:for-each>
        <xsl:for-each select="$node/oe:version_id">
            <version_id><xsl:value-of select="."/></version_id>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="archetype_details">
        <xsl:param name="archetype_node_id"/>
        <xsl:param name="template_id"/>
        
        <archetype_details>
            <archetype_id>
                <value>
                    <xsl:value-of select="$archetype_node_id"/>
                </value>
            </archetype_id>
            <xsl:if test="$template_id">
                <template_id>
                    <value>
                        <xsl:value-of select="$template_id"/>
                    </value>
                </template_id>
            </xsl:if>
            <rm_version>1.0.1</rm_version><!-- hard-coded -->
        </archetype_details>
    </xsl:template>
    
    <!--if RM_attribute has code-phrase then call-template for code-phrase elements and values
    otherwise use apply-templates -->
    
    <xsl:template match="*[@type='CLUSTER']">
        <xsl:param name="currNode"/>

        <xsl:attribute name="xsi:type">CLUSTER</xsl:attribute>
        <xsl:attribute name="archetype_node_id">
            <xsl:value-of select="@archetype_node_id"/>
        </xsl:attribute>          
        
        <xsl:call-template name="generate-name-any-links-and-any-archetype-details">
            <xsl:with-param name="currNode" select="."/>
        </xsl:call-template>
        
        <xsl:for-each select="$currNode/node()[@type]">
            <items>
                <xsl:apply-templates select=".">
                    <xsl:with-param name="currNode" select="."/>
                </xsl:apply-templates>
            </items>
        </xsl:for-each>
    
    </xsl:template>
    
    <xsl:template match="*[@type='ELEMENT']">
        <xsl:param name="currNode"/>
        <xsl:param name="isAssumedAsElement"/><!-- sb: added 26/02/08 [EHR-533] -->
            
        <xsl:choose>
            <xsl:when test="isAssumedAsElement='true'"></xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="xsi:type">ELEMENT</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:attribute name="archetype_node_id">
            <xsl:value-of select="$currNode/@archetype_node_id"/>
        </xsl:attribute>
        
        <xsl:call-template name="generate-name-any-links-and-any-archetype-details">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
            
        <!-- [MCA-25] sb 21/02/08 add condition on value element if have element with value only otherwise there is no element value (the latter is because of HL7 msg having a "" (overwrite
        value with no value...or 'null'???)). -->
        <xsl:if test="$currNode/node()[contains(name(), 'value')]">
            <value>
                <xsl:choose>
                    <!-- no xsi:type specified because it has been constrained in the TDS - usually if it is a CODED_TEXT -->
                    <xsl:when test="$currNode/*[contains(name(), 'value')]/*[local-name()='defining_code']">
                        <!-- CODED_TEXT -->
                        <xsl:call-template name="CODED_TEXT">
                            <xsl:with-param name="currNode" select="$currNode/*[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- sb: added 05/02/08 to support TDD 'valueType' attribute -->
                    <!-- DV_TEXT only -->
                    <xsl:when test="$currNode/@valueType='DV_TEXT' and not($currNode/*[contains(name(), 'value')]/*[local-name()='defining_code'])">
                        <xsl:call-template name="DV_TEXT">
                            <xsl:with-param name="currNode" select="$currNode/*[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- DV_DATE_TIME -->
                    <xsl:when test="$currNode/@valueType='DV_DATE_TIME'">
                        <xsl:call-template name="DV_DATE_TIME">
                            <xsl:with-param name="currNode" select="$currNode/*[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- DATA_VALUE ('any' datatype) -->
                    <xsl:when test="$currNode/@valueType='DATA_VALUE'">
                        <xsl:apply-templates select="$currNode/*[contains(name(), 'value') and @xsi:type]">
                            <xsl:with-param name="currNode" select="$currNode/*[contains(name(), 'value') and @xsi:type]"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <!-- DV_ORDINAL -->
                    <xsl:when test="$currNode/@valueType='DV_ORDINAL'">
                        <xsl:call-template name="DV_ORDINAL">
                            <xsl:with-param name="currNode" select="$currNode/*[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- DV_QUANTITY (13/08/08) -->
                    <xsl:when test="$currNode/@valueType='DV_QUANTITY'">                         
                        <xsl:call-template name="DV_QUANTITY">
                            <xsl:with-param name="currNode" select="$currNode/node()[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- DV_BOOLEAN (25/08/08) -->
                    <xsl:when test="$currNode/@valueType='DV_BOOLEAN'">                         
                        <xsl:call-template name="DV_BOOLEAN">
                            <xsl:with-param name="currNode" select="$currNode/node()[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- DV_COUNT (25/08/08) -->
                    <xsl:when test="$currNode/@valueType='DV_COUNT'">                         
                        <xsl:call-template name="DV_COUNT">
                            <xsl:with-param name="currNode" select="$currNode/node()[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- DV_DURATION(25/08/08) -->
                    <xsl:when test="$currNode/@valueType='DV_DURATION'">                         
                        <xsl:call-template name="DV_DURATION">
                            <xsl:with-param name="currNode" select="$currNode/node()[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- DV_DATE(25/08/08) -->
                    <xsl:when test="$currNode/@valueType='DV_DATE'">
                        <xsl:call-template name="DV_DATE">
                            <xsl:with-param name="currNode" select="$currNode/node()[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- DV_TIME(25/08/08) -->
                    <xsl:when test="$currNode/@valueType='DV_TIME'">
                        <xsl:call-template name="DV_TIME">
                            <xsl:with-param name="currNode" select="$currNode/node()[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="contains($currNode/@valueType, 'DV_INTERVAL')">
                        <xsl:call-template name="DV_INTERVAL">
                            <xsl:with-param name="currNode" select="$currNode/node()[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- DV_PROPORTION (20/03/09) -->
                    <xsl:when test="$currNode/@valueType='DV_PROPORTION'">
                        <xsl:call-template name="DV_PROPORTION">
                            <xsl:with-param name="currNode" select="$currNode/node()[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                	<!-- DV_IDENTIFIER -->
                	<xsl:when test="$currNode/@valueType='DV_IDENTIFIER'">
                		<xsl:call-template name="DV_IDENTIFIER">
                			<xsl:with-param name="currNode" select="$currNode/node()[contains(name(), 'value')]"/>
                		</xsl:call-template>
                	</xsl:when>
                	<!-- DV_MULTIMEDIA (20/03/09) -->
                    <xsl:when test="$currNode/@valueType='DV_MULTIMEDIA'">
                        <xsl:call-template name="DV_MULTIMEDIA">
                            <xsl:with-param name="currNode" select="$currNode/node()[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- DV_PARSABLE (20/03/09) -->
                    <xsl:when test="$currNode/@valueType='DV_PARSABLE'">
                        <xsl:call-template name="DV_PARSABLE">
                            <xsl:with-param name="currNode" select="$currNode/node()[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- DV_URI (20/03/09) -->
                    <xsl:when test="$currNode/@valueType='DV_URI'">
                        <xsl:call-template name="DV_URI">
                            <xsl:with-param name="currNode" select="$currNode/node()[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- DV_EHR_URI (20/03/09) -->
                    <xsl:when test="$currNode/@valueType='DV_EHR_URI'">
                        <xsl:call-template name="DV_EHR_URI">
                            <xsl:with-param name="currNode" select="$currNode/node()[contains(name(), 'value')]"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Handle choice datatypes in TDD - e.g. <QUANTITY_value> -->
                        <xsl:apply-templates select="$currNode/node()[contains(name(), 'value')][@xsi:type]">
                            <xsl:with-param name="currNode" select="$currNode/node()[contains(name(), 'value')][@xsi:type]"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </value>
        </xsl:if>
        <xsl:if test="$currNode/node()[contains(name(), 'null_flavour')]">
            <null_flavour>
                <value><xsl:value-of select="$currNode/*[local-name()='null_flavour']/*[local-name()='value']"/></value>
                <defining_code>
                    <terminology_id>
                        <value>openehr</value>
                    </terminology_id>
                    <code_string><xsl:value-of select="$currNode/*[local-name()='null_flavour']/*[local-name()='defining_code']/*[local-name()='code_string']"/></code_string>
                </defining_code>
            </null_flavour>
        </xsl:if>
            
    </xsl:template>
    
    <xsl:template match="*[@type='SECTION']">
        <xsl:param name="currNode"/>
            
        <xsl:attribute name="xsi:type">SECTION</xsl:attribute>
        <xsl:attribute name="archetype_node_id">
            <xsl:value-of select="$currNode/@archetype_node_id"/>
        </xsl:attribute>
        
        <xsl:call-template name="generate-name-any-links-and-any-archetype-details">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
                    
        <!-- Because this is under SECTION all items directly under it are 'items' so must do a for-each in this case -->
        <xsl:choose>
            <xsl:when test="$currNode[@name!='']"><!-- new TDS version 3 -->
                <xsl:for-each select="$currNode/*[@type]">
                    <items>
                        <xsl:apply-templates select=".">
                            <xsl:with-param name="currNode" select="."/>
                        </xsl:apply-templates>
                    </items>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
        <!-- sb: 19/12/07 fixed select statement to ensure the correct nodeset is selected which is children of SECTION except for 'name' element and added back 'items' element -->
        <xsl:for-each select="$currNode/*[local-name()='name']/following-sibling::*[@type]">
            <items>
                <xsl:apply-templates select=".">
                    <xsl:with-param name="currNode" select="."/>
                </xsl:apply-templates>
            </items>
        </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="*[@type='ACTION']">
        <xsl:param name="currNode"/>
            
        <xsl:attribute name="xsi:type">ACTION</xsl:attribute>
        <xsl:attribute name="archetype_node_id">
            <xsl:value-of select="$currNode/@archetype_node_id"/>
        </xsl:attribute>
        
        <xsl:call-template name="generate-name-any-links-and-any-archetype-details">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
            
            <xsl:call-template name="ENTRY">
                <xsl:with-param name="currNode" select="$currNode"/>
            </xsl:call-template>
            
            <xsl:call-template name="CARE_ENTRY">
                <xsl:with-param name="currNode" select="$currNode"/>
            </xsl:call-template>
            
            <xsl:if test="$currNode/*[local-name()='time']">
                <time>
                    <xsl:call-template name="DATE_TIME">
                        <xsl:with-param name="currNode" select="$currNode/*[local-name()='time']"/>
                    </xsl:call-template>
                </time>
            </xsl:if>
            
            <!-- description only occurs once so don't need for-each -->
            <description>
                <xsl:apply-templates select="$currNode/node()[@type and local-name()!='protocol']">
                    <xsl:with-param name="currNode" select="$currNode/node()[@type and local-name()!='protocol']"/>
                </xsl:apply-templates>
            </description>
            
            <ism_transition>
                <current_state>
                    <xsl:call-template name="CODED_TEXT">
                        <xsl:with-param name="currNode" select="$currNode/*[local-name()='ism_transition']/*[local-name()='current_state']"/>
                    </xsl:call-template>
                </current_state>
                <xsl:if test="$currNode/*[local-name()='ism_transition']/*[local-name()='transition']">
                    <transition>
                        <xsl:call-template name="CODED_TEXT">
                            <xsl:with-param name="currNode" select="$currNode/*[local-name()='ism_transition']/*[local-name()='transition']"/>
                        </xsl:call-template>
                    </transition>
                </xsl:if>
                <xsl:if test="$currNode/*[local-name()='ism_transition']/*[local-name()='careflow_step']">
                    <careflow_step>
                        <xsl:call-template name="CODED_TEXT">
                            <xsl:with-param name="currNode" select="$currNode/*[local-name()='ism_transition']/*[local-name()='careflow_step']"/>
                        </xsl:call-template>
                    </careflow_step>
                </xsl:if>
            </ism_transition>
            
            <xsl:if test="$currNode/*[local-name()='instruction_details']">
                <instruction_details>
                    <instruction_id>
                        <xsl:call-template name="LOCATABLE_REF">
                            <xsl:with-param name="currNode" select="$currNode/*[local-name()='instruction_details']/*[local-name()='instruction_id']"/>
                        </xsl:call-template>
                    </instruction_id>
                    <activity_id>
                        
                    </activity_id>
                    <xsl:if test="$currNode/*[local-name()='instruction_details']/*[local-name()='wf_details']">
                        <wf_details>
                            <xsl:apply-templates select="$currNode/*[local-name()='instruction_details']/*[local-name()='wf_details']">
                                <xsl:with-param name="currNode" select="$currNode/*[local-name()='instruction_details']/*[local-name()='wf_details']"/>
                            </xsl:apply-templates>
                        </wf_details>
                    </xsl:if>
                </instruction_details>
            </xsl:if>
            
        
    </xsl:template>
   
    <xsl:template match="*[@type='INSTRUCTION']">
        <xsl:param name="currNode"/>
            
            <xsl:attribute name="xsi:type">INSTRUCTION</xsl:attribute>
            <xsl:attribute name="archetype_node_id">
                <xsl:value-of select="$currNode/@archetype_node_id"/>
            </xsl:attribute>
            
            <xsl:call-template name="generate-name-any-links-and-any-archetype-details">
                <xsl:with-param name="currNode" select="$currNode"/>
            </xsl:call-template>
            
            <xsl:call-template name="ENTRY">
                <xsl:with-param name="currNode" select="$currNode"/>
            </xsl:call-template>
            
            <xsl:call-template name="CARE_ENTRY">
                <xsl:with-param name="currNode" select="$currNode"/>
            </xsl:call-template>
            
            <narrative>
                <xsl:call-template name="TEXT">
                    <xsl:with-param name="currNode" select="*[local-name()='narrative']"/>
                </xsl:call-template>
            </narrative>
            
            <xsl:if test="$currNode/*[local-name()='expiry_time']">
                <expiry_time>
                    <xsl:call-template name="DATE_TIME">
                        <xsl:with-param name="currNode" select="$currNode/*[local-name()='expiry_time']"/>
                    </xsl:call-template>
                </expiry_time>
            </xsl:if>
            
            <xsl:if test="$currNode/*[local-name()='wf_definition']">
                <wf_definition>
                    <xsl:call-template name="PARSABLE">
                        <xsl:with-param name="currNode" select="$currNode/*[local-name()='wf_definition']"/>
                    </xsl:call-template>
                </wf_definition>
            </xsl:if>
            
            <xsl:call-template name="ACTIVITY">
                <xsl:with-param name="currNode" select="node()[@type='ACTIVITY']"/>
            </xsl:call-template>
        
    </xsl:template>
   
    <xsl:template name="ACTIVITY">
        <xsl:param name="currNode"/>
        <activities>
            
            <xsl:attribute name="archetype_node_id">
                <xsl:value-of select="$currNode/@archetype_node_id"/>
            </xsl:attribute>
            
            <name>
                <xsl:choose>
                <xsl:when test="$currNode/@name">
                    <xsl:call-template name="TEXTV2"><!-- original TDS format -->
                        <xsl:with-param name="currNode" select="$currNode"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="TEXT"><!-- original TDS format -->
                <xsl:with-param name="currNode" select="$currNode/*[local-name()='name']"/>
            </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            </name>
            
            <!-- description only occurs once so don't need for-each -->
            <description>
                <xsl:apply-templates select="$currNode/*[@type]">
                    <xsl:with-param name="currNode" select="$currNode/*[@type]"/>
                </xsl:apply-templates>
            </description>
            
            <timing>
                <xsl:call-template name="PARSABLE">
                    <xsl:with-param name="currNode" select="$currNode/*[local-name()='timing']"/>
                </xsl:call-template>
            </timing>
            
            <action_archetype_id>
                <xsl:value-of select="$currNode/*[local-name()='action_archetype_id']/text()"/>
            </action_archetype_id>
            
        </activities>
        
    </xsl:template>
   
    <xsl:template match="*[@type='ADMIN_ENTRY']">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">ADMIN_ENTRY</xsl:attribute>
        <xsl:attribute name="archetype_node_id">
            <xsl:value-of select="$currNode/@archetype_node_id"/>
        </xsl:attribute>
            
        <xsl:call-template name="generate-name-any-links-and-any-archetype-details">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
        
        <xsl:call-template name="ENTRY">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
        
        <data>
            <xsl:apply-templates select="node()[@type]">
                <xsl:with-param name="currNode" select="node()[@type]"/>
            </xsl:apply-templates>
        </data>
        
    </xsl:template>
    
    <xsl:template match="*[@type='EVALUATION']">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">EVALUATION</xsl:attribute>
        <xsl:attribute name="archetype_node_id">
            <xsl:value-of select="$currNode/@archetype_node_id"/>
        </xsl:attribute>
            
        <xsl:call-template name="generate-name-any-links-and-any-archetype-details">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
            
        <xsl:call-template name="ENTRY">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
        
        <xsl:call-template name="CARE_ENTRY">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
            
        <data>
            <xsl:apply-templates select="$currNode/*[local-name()='data']">
                <xsl:with-param name="currNode" select="$currNode/*[local-name()='data']"/>
            </xsl:apply-templates>
        </data>
        
    </xsl:template>
      
    <xsl:template match="*[@type='OBSERVATION']">
        <xsl:param name="currNode"/>
            
        <xsl:attribute name="xsi:type">OBSERVATION</xsl:attribute>
        <xsl:attribute name="archetype_node_id">
            <xsl:value-of select="$currNode/@archetype_node_id"/>
        </xsl:attribute>
            
        <xsl:call-template name="generate-name-any-links-and-any-archetype-details">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
            
        <xsl:call-template name="ENTRY">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
        
        <xsl:call-template name="CARE_ENTRY">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
            
        <data>
            <xsl:choose>
                <!-- IF type attribute is specified in the data element node -->
                <xsl:when test="$currNode/*[local-name()='data']/@type">
                    <xsl:apply-templates select="$currNode/*[local-name()='data']">
                        <xsl:with-param name="currNode" select="$currNode/*[local-name()='data']"/>
                    </xsl:apply-templates>    
                </xsl:when>
                <!-- default type is HISTORY and call-template HISTORY -->
                <xsl:otherwise>
                    <xsl:call-template name="HISTORY">
                        <xsl:with-param name="currNode" select="$currNode/*[local-name()='data']"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>                
        </data>
            
        <xsl:if test="$currNode/*[local-name()='state']/*">
            <state>
                <xsl:choose>
                    <!-- IF type attribute is specified in the state element node -->
                    <xsl:when test="$currNode/*[local-name()='state']/@type">
                        <xsl:apply-templates select="$currNode/*[local-name()='state']">
                            <xsl:with-param name="currNode" select="$currNode/*[local-name()='state']"/>
                        </xsl:apply-templates>    
                    </xsl:when>
                </xsl:choose>
            </state>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template name="HISTORY">
        <xsl:param name="currNode"/>
        
        <!--[EHR-533] sb removed as this is already assumed from openehr schema 25/02/08 <xsl:attribute name="xsi:type">HISTORY</xsl:attribute>-->
        <xsl:attribute name="archetype_node_id">
            <xsl:value-of select="$currNode/@archetype_node_id"/>
        </xsl:attribute>
        
        <name>
            <value>data</value>
        </name>
        
        <xsl:choose>
            <xsl:when test="$currNode/*[local-name()='origin'] and $currNode/*[local-name()='origin']/*[local-name()='value']!=''">
                <origin>
                    <xsl:call-template name="DATE_TIME">
                        <xsl:with-param name="currNode" select="$currNode/*[local-name()='origin']"/>
                    </xsl:call-template>
                </origin>
            </xsl:when>
            <xsl:otherwise><origin xsi:nil='true'/></xsl:otherwise>
        </xsl:choose>
        
        <xsl:if test="$currNode/*[local-name()='period']">
            <period>
                <xsl:call-template name="DURATION">
                    <xsl:with-param name="currNode" select="$currNode/*[local-name()='period']"/>
                </xsl:call-template>
            </period>
        </xsl:if>
        
        <xsl:if test="$currNode/*[local-name()='duration']">
            <duration>
                <xsl:call-template name="DURATION">
                    <xsl:with-param name="currNode" select="$currNode/*[local-name()='duration']"/>
                </xsl:call-template>
            </duration>
        </xsl:if>
        
        <xsl:for-each select="$currNode/node()[@type='POINT_EVENT' or @type='INTERVAL_EVENT']">
            <!-- there's no events node in the TDD so need to add this bit -->
            <events>
                
                <xsl:variable name="event-type"><xsl:value-of select="@type"/></xsl:variable>
                
                <xsl:attribute name="xsi:type"><xsl:value-of select="$event-type"/></xsl:attribute>
                <xsl:attribute name="archetype_node_id">
                    <xsl:value-of select="@archetype_node_id"/>
                </xsl:attribute>
                
                <name>
                        <!-- get name of element and make sure this either has POINT EVENT type value IF GIVEN or else check it will have an archetype_node_id ... this ensures the 'origin' element is not selected -->
                        <!--Commented out 27/08/08 <xsl:for-each select="$currNode/node()[@archetype_node_id]">
                            <xsl:call-template name="formatName">
                                <xsl:with-param name="nodeName" select="name()"/>
                            </xsl:call-template>
                            </xsl:for-each>-->
                        <xsl:choose>
                            <xsl:when test="@name!=''">
                                <xsl:call-template name="TEXTV2"><!-- original TDS format -->
                                    <xsl:with-param name="currNode" select="."/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <value>
                                    <xsl:value-of select="*[local-name()='name']/*[local-name()='value']"/>
                                </value>
                            </xsl:otherwise>
                        </xsl:choose>
                </name>
                
                <time>
                    <xsl:call-template name="DATE_TIME">
                        <xsl:with-param name="currNode" select="*[local-name()='time']"/>
                    </xsl:call-template>
                </time>
                
                <data>
                    <xsl:apply-templates select="*[local-name()='data' and @type]">
                        <xsl:with-param name="currNode" select="*[local-name()='data' and @type]"/>
                    </xsl:apply-templates>                    
                </data>
                
                <xsl:if test="*[local-name()='state']/*">
                    <state>
                        <xsl:apply-templates select="*[local-name()='state' and @type]">
                            <xsl:with-param name="currNode" select="*[local-name()='state' and @type]"/>
                        </xsl:apply-templates>
                    </state>
                </xsl:if>
                
                <xsl:choose>
                    <xsl:when test="$event-type='INTERVAL_EVENT'">
                        <!--<xs:element name="width" type="DV_DURATION"/>
                            <xs:element name="sample_count" type="xs:int" minOccurs="0"/>
                            <xs:element name="math_function" type="DV_CODED_TEXT"/>-->
                        <width>
                            <value><xsl:value-of select="*[local-name()='width']/*[local-name()='value']"/></value>
                        </width>
                        <!-- TODO (FUTURE): sample count (integer) attribute -->
                        <math_function>
                            <value><xsl:value-of select="*[local-name()='math_function']/*[local-name()='value']"/></value>
                            <defining_code>
                                <terminology_id>
                                    <value>openehr</value>
                                </terminology_id>
                                <code_string><xsl:value-of select="*[local-name()='math_function']/*[local-name()='defining_code']/*[local-name()='code_string']"/></code_string>
                            </defining_code>
                        </math_function>
                    </xsl:when>
                </xsl:choose>
                
            </events>
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template match="*[@*='ITEM_SINGLE']">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">ITEM_SINGLE</xsl:attribute>
        <xsl:attribute name="archetype_node_id">
            <xsl:value-of select="@archetype_node_id"/>
        </xsl:attribute> 
        
        <!-- sb: 19/12/07 added test to see if it has a 'name' element otherwise
            it is a 'data' or 'protocol' (or some other element collapsed in TDD) which has no 'name' element in TDD -->
        <name>
            <xsl:choose>
                <xsl:when test="*[local-name()='name']">
                    <xsl:call-template name="TEXT">
                        <xsl:with-param name="currNode" select="*[local-name()='name']"/>
                    </xsl:call-template>
                </xsl:when>
                <!-- assume name is whatever is in the TDD element name -->
                <xsl:otherwise>
                    <value>
                        <xsl:value-of select="name()"/>
                    </value>
                </xsl:otherwise>
            </xsl:choose>
        </name>
        
        <xsl:apply-templates select="*[local-name()='links']"/>
        <!--<xsl:if test="@template_id">-->
        <xsl:if test="not(starts-with(@archetype_node_id, 'at'))">
            <xsl:call-template name="archetype_details">
                <xsl:with-param name="archetype_node_id" select="@archetype_node_id"/>
                <xsl:with-param name="template_id" select="@template_id"/>
            </xsl:call-template>
        </xsl:if>
        
        <item>
            <xsl:call-template name="ASSUMED_ELEMENT">
                <xsl:with-param name="currNode" select="$currNode/*"/>
            </xsl:call-template>
        </item>
        
    </xsl:template>
    
    <xsl:template match="*[@*='ITEM_LIST']">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">ITEM_LIST</xsl:attribute>
        <xsl:attribute name="archetype_node_id">
            <xsl:value-of select="@archetype_node_id"/>
        </xsl:attribute> 
            
        <!-- sb: 19/12/07 added test to see if it has a 'name' element otherwise
        it is a 'data' or 'protocol' (or some other element collapsed in TDD) which has no 'name' element in TDD -->
        <name>
            <xsl:choose>
                <xsl:when test="*[local-name()='name']">            
                    <xsl:call-template name="TEXT">
                        <xsl:with-param name="currNode" select="*[local-name()='name']"/>
                    </xsl:call-template>
                </xsl:when>
                <!-- assume name is whatever is in the TDD element name -->
                <xsl:otherwise>
                    <value>
                        <xsl:value-of select="name()"/>
                    </value>
                </xsl:otherwise>
            </xsl:choose>
        </name>
        <xsl:apply-templates select="*[local-name()='links']"/>
        <!--<xsl:if test="@template_id">-->
        <xsl:if test="not(starts-with(@archetype_node_id, 'at'))">
            <xsl:call-template name="archetype_details">
                <xsl:with-param name="archetype_node_id" select="@archetype_node_id"/>
                <xsl:with-param name="template_id" select="@template_id"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- because this is under ITEM_LIST all items directly under it are 'items' so 
            must do a for-each in this case -->      
        <xsl:for-each select="$currNode/*[@type]">
            <items>
                <xsl:call-template name="ASSUMED_ELEMENT">
                    <xsl:with-param name="currNode" select="."/>
                </xsl:call-template>
            </items>
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template match="*[@*='ITEM_TREE']">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">ITEM_TREE</xsl:attribute>
        <xsl:attribute name="archetype_node_id">
            <xsl:value-of select="$currNode/@archetype_node_id"/>
        </xsl:attribute>
       
        <!-- sb: 19/12/07 added test to see if it has a 'name' element otherwise
            it is a 'data' or 'protocol' (or some other element collapsed in TDD) which has no 'name' element in TDD -->
        <name>
            <xsl:choose>
                <xsl:when test="*[local-name()='name']">
                    <xsl:call-template name="TEXT">
                        <xsl:with-param name="currNode" select="*[local-name()='name']"/>
                    </xsl:call-template>
                </xsl:when>
                <!-- assume name is whatever is in the TDD element name -->
                <xsl:otherwise>
                    <value>
                        <xsl:value-of select="name()"/>
                    </value>
                </xsl:otherwise>
            </xsl:choose>
        </name>

        <xsl:apply-templates select="*[local-name()='links']"/>
        <!--<xsl:if test="@template_id">-->
        <xsl:if test="not(starts-with(@archetype_node_id, 'at'))">
            <xsl:call-template name="archetype_details">
                <xsl:with-param name="archetype_node_id" select="$currNode/@archetype_node_id"/>
                <xsl:with-param name="template_id" select="$currNode/@template_id"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- because this is under ITEM_TREE all items directly under it are 'items' so 
            must do a for-each in this case -->      
        <xsl:for-each select="$currNode/*[@type]">
            <items>
                <xsl:apply-templates select=".">
                    <xsl:with-param name="currNode" select="."/>
                </xsl:apply-templates>
            </items>
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template match="*[@type='HISTORY']">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="archetype_node_id">
            <xsl:value-of select="$currNode/@archetype_node_id"/>
        </xsl:attribute>
        
        <name>
            <value>data</value>
        </name>
        
        <xsl:choose>
            <xsl:when test="$currNode/*[local-name()='origin'] and $currNode/*[local-name()='origin']/*[local-name()='value']!=''">
                <origin>
                    <xsl:call-template name="DATE_TIME">
                        <xsl:with-param name="currNode" select="$currNode/*[local-name()='origin']"/>
                    </xsl:call-template>
                </origin>
            </xsl:when>
            <xsl:otherwise><origin xsi:nil='true'/></xsl:otherwise>
        </xsl:choose>
        
        <events>
            
        </events>
    </xsl:template>
    
    <xsl:template name="ENTRY">
        <xsl:param name="currNode"/>
        
        <xsl:choose>
            <xsl:when test="$currNode/@language!='' and $currNode/@encoding!=''"><!-- new simplified TDS format (v3) -->
        <language>
                    <terminology_id>
                        <value>ISO_639-1</value>
                    </terminology_id>
                    <code_string><xsl:value-of select="$currNode/@language"/></code_string>
                </language>
                <encoding>
                    <terminology_id>
                        <value>IANA_character-sets</value>
                    </terminology_id>
                    <code_string><xsl:value-of select="$currNode/@encoding"/></code_string>
                </encoding>
            </xsl:when>
            <xsl:otherwise><!-- original TDS format -->
                <language>
            <xsl:call-template name="CODE_PHRASE">
                <xsl:with-param name="currNode" select="$currNode/*[local-name()='language']"/>
            </xsl:call-template>    
        </language>
        <encoding>
            <xsl:call-template name="CODE_PHRASE">
                <xsl:with-param name="currNode" select="$currNode/*[local-name()='encoding']"/>
            </xsl:call-template>  
        </encoding>
            </xsl:otherwise>
        </xsl:choose>
        <subject>
        <xsl:call-template name="PARTY_PROXY">
            <xsl:with-param name="currNode" select="$currNode/*[local-name()='subject']"/>
        </xsl:call-template>
        </subject>
        <xsl:if test="$currNode/*[local-name()='provider']">
            <provider>
                <xsl:call-template name="PARTY_PROXY">
                    <xsl:with-param name="currNode" select="$currNode/*[local-name()='provider']"/>
                </xsl:call-template>
            </provider>
        </xsl:if>
        <xsl:for-each select="$currNode/*[local-name()='other_participations']">
            <other_participations>
                <!-- TO DO - explicitly copy the participation -->
                <xsl:copy-of select="./*"/>
            </other_participations>
        </xsl:for-each>
        <xsl:for-each select="$currNode/*[local-name()='work_flow_id']">
            <work_flow_id>
                <xsl:call-template name="OBJECT_REF">
                    <xsl:with-param name="currNode" select="."/>
                </xsl:call-template>
            </work_flow_id>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="CARE_ENTRY">
        <xsl:param name="currNode"/>
        
        <xsl:if test="$currNode/*[local-name()='protocol']">
            <protocol>
                <!-- IF type attribute is specified in the data element node -->
                <xsl:apply-templates select="$currNode/*[local-name()='protocol']">
                    <xsl:with-param name="currNode" select="$currNode/*[local-name()='protocol']"/>
                </xsl:apply-templates>
            </protocol>
        </xsl:if>
        <xsl:if test="$currNode/*[local-name()='guideline_id']">
            <guideline_id>
                <xsl:value-of select="$currNode/*[local-name()='guideline_id']"/>
            </guideline_id>
        </xsl:if>
    </xsl:template>
                   
     <xsl:template name="DATE_TIME">
         <xsl:param name="currNode"/>
         <value>
             <xsl:value-of select="$currNode/*[local-name()='value']"/>
         </value>
     </xsl:template>
     
    <xsl:template name="PARSABLE">
        <xsl:param name="currNode"/>
        
        <value>
            <xsl:value-of select="$currNode/*[local-name()='value']"/>
        </value>
        <formalism>
            <xsl:value-of select="$currNode/*[local-name()='formalism']"/>
        </formalism>
    </xsl:template>
    
    <xsl:template name="LOCATABLE_REF">
        <xsl:param name="currNode"/>
        
        <id>
            <value>
                <xsl:value-of select="$currNode/*[local-name()='id']/*[local-name()='value']"/>
            </value>
        </id>
        <namespace>
            <xsl:value-of select="$currNode/*[local-name()='namespace']"/>
        </namespace>
        <type>
            <xsl:value-of select="$currNode/*[local-name()='type']"/>
        </type>
        <xsl:choose>      
            <xsl:when test="$currNode/*[local-name()='path']">
            <path>
                <xsl:value-of select="$currNode/*[local-name()='path']"/>
            </path>
        </xsl:when>
            <xsl:when test="$currNode/*[local-name()='path']">
                <path>
                    <xsl:value-of select="$currNode/*[local-name()='path']"/>
                </path>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
     
    <xsl:template name="DURATION">
        <xsl:param name="currNode"/>
        <value>
            <xsl:value-of select="$currNode/*[local-name()='value']"/>
        </value>
    </xsl:template>
     
     <xsl:template match="*[@*='oe:PARTY_IDENTIFIED']">

         <!--<xsl:attribute name="xsi:type">PARTY_IDENTIFIED</xsl:attribute>

         <xsl:if test="*[local-name()='name']/text()">
             <name>
                 <xsl:value-of select="*[local-name()='name']/text()"/>
             </name>
         </xsl:if>
         <xsl:if test="*[local-name()='identifiers']/*[local-name()='id']/text()">
             <identifiers>
                 <issuer>
                     <xsl:value-of select="*[local-name()='identifiers']/*[local-name()='issuer']/text()"/>
                 </issuer>
                 <assigner>
                     <xsl:value-of select="*[local-name()='identifiers']/*[local-name()='assigner']/text()"/>
                 </assigner>
                 <id>
                     <xsl:value-of select="*[local-name()='identifiers']/*[local-name()='id']/text()"/>
                 </id>
                 <type>
                     <xsl:value-of select="*[local-name()='identifiers']/*[local-name()='type']/text()"/>
                 </type>
             </identifiers>
             </xsl:if>-->
         <xsl:call-template name="PARTY_IDENTIFIED"/>
     </xsl:template>
     
    <xsl:template match="*[@*='oe:PARTY_SELF']">

        <xsl:attribute name="xsi:type">PARTY_SELF</xsl:attribute>
        <xsl:call-template name="generate-external-ref">
            <xsl:with-param name="currNode" select="."/>
        </xsl:call-template>
    </xsl:template>
     
     <xsl:template match="*[@*='oe:DV_STATE']">

         <value>
             <xsl:attribute name="xsi:type">DV_STATE</xsl:attribute>
             <value>
                 <xsl:value-of select="*[local-name()='value']"/>
             </value>
             <is_terminal>
                 <xsl:value-of select="*[local-name()='is_terminal']"/>
             </is_terminal>
         </value>
     </xsl:template>
    
    <xsl:template match="*[@*='oe:DV_IDENTIFIER']">

         <!--<issuer>
             <xsl:value-of select="*[local-name()='issuer']"/>
         </issuer>
         <assigner>
             <xsl:value-of select="*[local-name()='assigner']"/>
         </assigner>
         <id>
             <xsl:value-of select="*[local-name()='id']"/>
         </id>
         <type>
             <xsl:value-of select="*[local-name()='type']"/>
             </type>-->
         <xsl:attribute name="xsi:type">DV_IDENTIFIER</xsl:attribute>
        <xsl:call-template name="DV_IDENTIFIER"/>
    </xsl:template>
    
    <xsl:template match="*[@*='oe:DV_BOOLEAN']">

         <xsl:attribute name="xsi:type">DV_BOOLEAN</xsl:attribute>
         <value>
             <xsl:value-of select="*[local-name()='value']"/>
         </value>
     </xsl:template>
     
     <xsl:template match="*[@*='oe:DV_INTERVAL']">
         
         <xsl:attribute name="xsi:type">DV_INTERVAL</xsl:attribute>

         <xsl:if test="node()[contains(local-name(), 'lower')]">
             <lower>
                 <xsl:attribute name="xsi:type"><xsl:value-of select="node()[contains(local-name(), 'lower')]/@xsi:type"/></xsl:attribute>
                 <xsl:apply-templates select="node()[contains(local-name(), 'lower') and @xsi:type]"/>
             </lower>
         </xsl:if>
         <xsl:if test="node()[contains(local-name(), 'upper')]">
             <upper>
                 <xsl:attribute name="xsi:type"><xsl:value-of select="node()[contains(local-name(), 'upper')]/@xsi:type"/></xsl:attribute>
                 <xsl:apply-templates select="node()[contains(local-name(), 'upper') and @xsi:type]"/>
             </upper>
         </xsl:if>
         <xsl:if test="node()[contains(local-name(), 'lower_included')]">
             <lower_included><xsl:value-of select="node()[contains(local-name(), 'lower_included')]"/></lower_included>
         </xsl:if>
         <xsl:if test="node()[contains(local-name(), 'upper_included')]">
             <upper_included><xsl:value-of select="node()[contains(local-name(), 'upper_included')]"/></upper_included>
         </xsl:if>
         <xsl:if test="node()[contains(local-name(), 'lower_unbounded')]">
             <lower_unbounded><xsl:value-of select="node()[contains(local-name(), 'lower_unbounded')]"/></lower_unbounded>
         </xsl:if>
         <xsl:if test="node()[contains(local-name(), 'upper_unbounded')]">
             <upper_unbounded><xsl:value-of select="node()[contains(local-name(), 'upper_unbounded')]"/></upper_unbounded>
         </xsl:if>
         
     </xsl:template>

    <xsl:template name="DV_INTERVAL">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">DV_INTERVAL</xsl:attribute>
        
        <xsl:if test="$currNode/*[local-name()='lower']">
            <lower>
                <xsl:attribute name="xsi:type">
                    <xsl:value-of select="$currNode/*[local-name()='lower']/@xsi:type"/>
                </xsl:attribute>
                <xsl:apply-templates select="$currNode/*[local-name()='lower']"/>
            </lower>
        </xsl:if>
        <xsl:if test="$currNode/*[local-name()='upper']">
            <upper>
                <xsl:attribute name="xsi:type">
                    <xsl:value-of select="$currNode/*[local-name()='upper']/@xsi:type"/>
                </xsl:attribute>
                <xsl:apply-templates select="$currNode/*[local-name()='upper']"/>
            </upper>
        </xsl:if>
        
        <xsl:if test="$currNode/*[local-name()='lower_included']">
            <lower_included>
                <xsl:value-of select="$currNode/*[local-name()='lower_included']"/>
            </lower_included>
        </xsl:if>
        
        <xsl:if test="$currNode/*[local-name()='upper_included']">
            <upper_included>
                <xsl:value-of select="$currNode/*[local-name()='upper_included']"/>
            </upper_included>
        </xsl:if>
        
        <xsl:if test="$currNode/*[local-name()='lower_unbounded']">
            <lower_unbounded>
                <xsl:value-of select="$currNode/*[local-name()='lower_unbounded']"/>
            </lower_unbounded>
        </xsl:if>
        
        <xsl:if test="$currNode/*[local-name()='upper_unbounded']">
            <upper_unbounded>
                <xsl:value-of select="$currNode/*[local-name()='upper_unbounded']"/>
            </upper_unbounded>
        </xsl:if>
        
    </xsl:template>

    <xsl:template match="*[@*='oe:DV_QUANTITY']">
        
        <xsl:attribute name="xsi:type">DV_QUANTITY</xsl:attribute>
        <xsl:call-template name="DV_ORDERED">
            <xsl:with-param name="currNode" select="."/>
        </xsl:call-template>
        <magnitude>
            <xsl:value-of select="*[local-name()='magnitude']"/>
        </magnitude>
        <units>
            <xsl:value-of select="*[local-name()='units']"/>
        </units>
        <xsl:if test="*[local-name()='precision']">
            <precision>
                <xsl:value-of select="*[local-name()='precision']"/>
            </precision>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="DV_IDENTIFIER">
        <xsl:param name="currNode" select="."/>
        <xsl:param name="fixedType">false</xsl:param><!-- if the type='DV_IDENTIFIER' is already fixed and assumed from the RM then = 'true'' -->

        <xsl:if test="$fixedType!='true' ">
    	<xsl:attribute name="xsi:type">DV_IDENTIFIER</xsl:attribute>
        </xsl:if>
    	<issuer>
             <xsl:value-of select="$currNode/*[local-name()='issuer']"/>
         </issuer>
         <assigner>
             <xsl:value-of select="$currNode/*[local-name()='assigner']"/>
         </assigner>
         <id>
             <xsl:value-of select="$currNode/*[local-name()='id']"/>
         </id>
         <type>
             <xsl:value-of select="$currNode/*[local-name()='type']"/>
         </type>
    </xsl:template>

    <xsl:template name="DV_BOOLEAN">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">DV_BOOLEAN</xsl:attribute>
        <value><xsl:value-of select="$currNode/*[local-name()='value']"/></value>
    </xsl:template>
    
    <xsl:template name="CODED_TEXT">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">DV_CODED_TEXT</xsl:attribute>
        <value>
            <xsl:value-of select="$currNode/*[local-name()='value']"/>
        </value>
        <xsl:call-template name="mappings">
            <xsl:with-param name="curr-node" select="$currNode"/>
        </xsl:call-template>
        
        <defining_code>
            <terminology_id>
                <value>
                    <xsl:value-of select="$currNode/*[local-name()='defining_code']/*[local-name()='terminology_id']/*[local-name()='value']"/>
                </value>
            </terminology_id>
            <code_string>
                <xsl:value-of select="$currNode/*[local-name()='defining_code']/*[local-name()='code_string']"/>
            </code_string>
        </defining_code>
    </xsl:template>
    
    <xsl:template name="DV_COUNT"><!-- 25/08/08 -->
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">DV_COUNT</xsl:attribute>
        <xsl:call-template name="DV_ORDERED">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
        <magnitude>
            <xsl:value-of select="$currNode/*[local-name()='magnitude']"/>
        </magnitude>
    </xsl:template>

    <xsl:template name="DV_DATE">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">DV_DATE</xsl:attribute>
        <value>
            <xsl:value-of select="$currNode/*[local-name()='value']"/>
        </value>
    </xsl:template>

    <xsl:template name="DV_DATE_TIME">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">DV_DATE_TIME</xsl:attribute>
        <value>
            <xsl:value-of select="$currNode/*[local-name()='value']"/>
        </value>
    </xsl:template>

    <xsl:template name="DV_DURATION">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">DV_DURATION</xsl:attribute>
        <xsl:call-template name="DV_ORDERED">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
        <value>
            <xsl:value-of select="$currNode/*[local-name()='value']"/>
        </value>
    </xsl:template>
    
    <xsl:template name="DV_EHR_URI">
        <xsl:param name="currNode"/>
        
        <value>
            <xsl:value-of select="$currNode/*[local-name()='value']"/>
        </value>
    </xsl:template>
    
    <xsl:template name="DV_MULTIMEDIA">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">DV_MULTIMEDIA</xsl:attribute>
        <xsl:if test="$currNode/*[local-name()='uri']">
            <uri>
                <value><xsl:value-of select="$currNode/*[local-name()='uri']/*[local-name()='value']"/></value>
            </uri>
        </xsl:if>
        <xsl:if test="$currNode/*[local-name()='data']">
            <data><xsl:value-of select="$currNode/*[local-name()='data']"/></data>
        </xsl:if>
        <media_type>
            <terminology_id>
                <value>
                    <xsl:value-of select="$currNode/*[local-name()='media_type']/*[local-name()='terminology_id']/*[local-name()='value']"/>
                </value>
            </terminology_id>
            <code_string>
                <xsl:value-of select="$currNode/*[local-name()='media_type']/*[local-name()='code_string']"/>
            </code_string>
        </media_type>
        <size>
            <xsl:value-of select="$currNode/*[local-name()='size']"/>
        </size>
    </xsl:template>
    
    <xsl:template name="DV_ORDERED">
        <xsl:param name="currNode"/>
        
        <xsl:apply-templates select="$currNode/*[local-name()='normal_range']"/>
        <xsl:apply-templates select="$currNode/*[local-name()='other_reference_ranges']"/>
        <xsl:if test="$currNode/*[local-name()='normal_status']">
            <normal_status>
                <terminology_id>
                    <value>
                        <xsl:value-of select="$currNode/*[local-name()='normal_status']/*[local-name()='terminology_id']/*[local-name()='value']"/>
                    </value>
                </terminology_id>
                <code_string>
                    <xsl:value-of select="$currNode/*[local-name()='normal_status']/*[local-name()='code_string']"/>
                </code_string>
            </normal_status>
        </xsl:if>
        <xsl:if test="$currNode/*[local-name()='magnitude_status']">
            <magnitude_status>
                <xsl:value-of select="$currNode/*[local-name()='magnitude_status']"/>
            </magnitude_status>
        </xsl:if>
        <xsl:if test="$currNode/*[local-name()='accuracy']">
            <accuracy>
                <xsl:value-of select="$currNode/*[local-name()='accuracy']"/>
            </accuracy>
        </xsl:if>
        <xsl:if test="$currNode/*[local-name()='accuracy_is_percent']">
            <accuracy_is_percent>
                <xsl:value-of select="$currNode/*[local-name()='accuracy_is_percent']"/>
            </accuracy_is_percent>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="DV_ORDINAL">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">DV_ORDINAL</xsl:attribute>
        <xsl:call-template name="DV_ORDERED">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
        <value>
            <xsl:value-of select="$currNode/*[local-name()='value']"/>
        </value>
        <symbol>
            <value>
                <xsl:value-of select="$currNode/*[local-name()='symbol']/*[local-name()='value']"/>
            </value>
            <xsl:choose>
                <xsl:when test="$currNode/*[local-name()='symbol']">
                    <xsl:call-template name="mappings">
                        <xsl:with-param name="curr-node" select="$currNode/*[local-name()='symbol']"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="mappings">
                        <xsl:with-param name="curr-node" select="$currNode/*[local-name()='symbol']"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            
            <defining_code>
                <terminology_id>
                    <value>
                        <xsl:value-of select="$currNode/*[local-name()='symbol']/*[local-name()='defining_code']/*[local-name()='terminology_id']/*[local-name()='value']"/>
                    </value>
                </terminology_id>
                <code_string>
                    <xsl:value-of select="$currNode/*[local-name()='symbol']/*[local-name()='defining_code']/*[local-name()='code_string']"/>
                </code_string>
            </defining_code>
        </symbol>
    </xsl:template>
    
    <xsl:template name="DV_PARSABLE">
        <xsl:param name="currNode"/>
        
        <value>
            <xsl:value-of select="$currNode/*[local-name()='value']"/>
        </value>
        <formalism>
            <xsl:value-of select="$currNode/*[local-name()='formalism']"/>
        </formalism>
    </xsl:template>
    
    <xsl:template name="DV_PROPORTION">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">DV_PROPORTION</xsl:attribute>
        <xsl:call-template name="DV_ORDERED">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
        
        <xsl:variable name="prop_type"> 
            <xsl:value-of select="$currNode/*[local-name()='type']"/>
        </xsl:variable>
        <xsl:variable name="denom_value"> 
            <xsl:value-of select="$currNode/*[local-name()='denominator']"/>
        </xsl:variable>
        
        <numerator>
            <xsl:value-of select="$currNode/*[local-name()='numerator']"/>
        </numerator>
        
        <denominator>
            <xsl:choose>
                <xsl:when test = "$prop_type='2' and $denom_value =''">100</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$currNode/*[local-name()='denominator']"/>
                </xsl:otherwise>
            </xsl:choose>       
        </denominator>
        <type>
            <xsl:value-of select="$prop_type"/>
        </type>
    </xsl:template>
    
    <xsl:template name="DV_QUANTITY">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">DV_QUANTITY</xsl:attribute>
        <xsl:call-template name="DV_ORDERED">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
        <magnitude><xsl:value-of select="$currNode/*[local-name()='magnitude']"/></magnitude>
        <units><xsl:value-of select="$currNode/*[local-name()='units']"/></units>
        <xsl:if test="$currNode/*[local-name()='precision']">
            <precision><xsl:value-of select="$currNode/*[local-name()='precision']"/></precision>
        </xsl:if>
    </xsl:template>
       
    <xsl:template name="DV_TEXT">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">DV_TEXT</xsl:attribute>
        <value>
            <xsl:value-of select="$currNode/*[local-name()='value']"/>
        </value>
        <xsl:call-template name="mappings">
            <xsl:with-param name="curr-node" select="$currNode"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="DV_TIME">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">DV_TIME</xsl:attribute>
        <value>
            <xsl:value-of select="$currNode/*[local-name()='value']"/>
        </value>
    </xsl:template>
       
    <xsl:template name="DV_URI">
        <xsl:param name="currNode"/>
        
        <value>
            <xsl:value-of select="$currNode/*[local-name()='value']"/>
        </value>
    </xsl:template>
    
    <xsl:template match="*[@*='oe:DV_COUNT']">
        
        <xsl:attribute name="xsi:type">DV_COUNT</xsl:attribute>
        <xsl:call-template name="DV_ORDERED">
            <xsl:with-param name="currNode" select="."/>
        </xsl:call-template>
        <magnitude>
            <xsl:value-of select="*[local-name()='magnitude']"/>
        </magnitude>
    </xsl:template>
    
    <xsl:template match="*[@*='oe:DV_PROPORTION']">
        
        <xsl:attribute name="xsi:type">DV_PROPORTION</xsl:attribute>
        <xsl:call-template name="DV_ORDERED">
            <xsl:with-param name="currNode" select="."/>
        </xsl:call-template>
        <xsl:variable name="prop_type"> 
            <xsl:value-of select="*[local-name()='type']"/>
        </xsl:variable>
        <xsl:variable name="denom_value"> 
            <xsl:value-of select="*[local-name()='denominator']"/>
        </xsl:variable>
        <numerator>
            <xsl:value-of select="*[local-name()='numerator']"/>
        </numerator>
        <denominator>
            <xsl:choose>
                <xsl:when test = "$prop_type='2' and $denom_value = ''">100  </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="*[local-name()='denominator']"/>
                </xsl:otherwise>
            </xsl:choose>       
        </denominator>
        <type>
            <xsl:value-of select="$prop_type"/>
        </type>
    </xsl:template>
     
     <xsl:template match="*[@*='oe:DV_ORDINAL']">
         
         <xsl:attribute name="xsi:type">DV_ORDINAL</xsl:attribute>
         <xsl:call-template name="DV_ORDERED">
             <xsl:with-param name="currNode" select="."/>
         </xsl:call-template>
         <value>
             <xsl:value-of select="*[local-name()='value']"/>
         </value>
         <symbol>
             <value>
                 <xsl:value-of select="*[local-name()='symbol']/*[local-name()='value']"/>
             </value>
             <xsl:choose>
                 <xsl:when test="*[local-name()='symbol']">
                     <xsl:call-template name="mappings">
                         <xsl:with-param name="curr-node" select="*[local-name()='symbol']"/>
                     </xsl:call-template>
                 </xsl:when>
                 <xsl:otherwise>
                     <xsl:call-template name="mappings">
                         <xsl:with-param name="curr-node" select="*[local-name()='symbol']"/>
                     </xsl:call-template>
                 </xsl:otherwise>
             </xsl:choose>
             
             <defining_code>
                 <terminology_id>
                     <value>
                         <xsl:value-of select="*[local-name()='symbol']/*[local-name()='defining_code']/*[local-name()='terminology_id']/*[local-name()='value']"/>
                     </value>
                 </terminology_id>
                 <code_string>
                     <xsl:value-of select="*[local-name()='symbol']/*[local-name()='defining_code']/*[local-name()='code_string']"/>
                 </code_string>
             </defining_code>
         </symbol>
     </xsl:template>
    
    <xsl:template match="*[@*='oe:DV_DATE_TIME']">
        
        <xsl:attribute name="xsi:type">DV_DATE_TIME</xsl:attribute>
        <xsl:call-template name="DV_ORDERED">
            <xsl:with-param name="currNode" select="."/>
        </xsl:call-template>
        <value>
            <xsl:value-of select="*[local-name()='value']"/>
        </value>
    </xsl:template>
    
    <xsl:template match="*[@*='oe:DV_DATE']">

        <xsl:attribute name="xsi:type">DV_DATE</xsl:attribute>
        <xsl:call-template name="DV_ORDERED">
            <xsl:with-param name="currNode" select="."/>
        </xsl:call-template>
        <value>
            <xsl:value-of select="*[local-name()='value']"/>
        </value>
    </xsl:template>
    
    <xsl:template match="*[@*='oe:DV_TIME']">

        <xsl:attribute name="xsi:type">DV_TIME</xsl:attribute>
        <xsl:call-template name="DV_ORDERED">
            <xsl:with-param name="currNode" select="."/>
        </xsl:call-template>
        <value>
            <xsl:value-of select="*[local-name()='value']"/>
        </value>
    </xsl:template>
    
    <xsl:template match="*[@*='oe:DV_TEXT']">
        
        <xsl:attribute name="xsi:type">DV_TEXT</xsl:attribute>
        <value>
            <xsl:value-of select="*[local-name()='value']"/>
        </value>
        <xsl:call-template name="mappings">
            <xsl:with-param name="curr-node" select="."/>
        </xsl:call-template>
        
    </xsl:template>
    
    <xsl:template match="*[@*='oe:DV_CODED_TEXT']">

        <xsl:attribute name="xsi:type">DV_CODED_TEXT</xsl:attribute>
        <value>
            <xsl:value-of select="*[local-name()='value']"/>
        </value>
        <xsl:call-template name="mappings">
            <xsl:with-param name="curr-node" select="."/>
        </xsl:call-template>
        
        <defining_code>
            <terminology_id>
                <value>
                    <xsl:value-of select="*[local-name()='defining_code']/*[local-name()='terminology_id']/*[local-name()='value']"/>
                </value>
            </terminology_id>
            <code_string>
                <xsl:value-of select="*[local-name()='defining_code']/*[local-name()='code_string']"/>
            </code_string>
        </defining_code>
    </xsl:template>
     
    <xsl:template match="*[@*='oe:DV_MULTIMEDIA']">
        
        <xsl:attribute name="xsi:type">DV_MULTIMEDIA</xsl:attribute>
        <media_type>
            <terminology_id>
                <value>
                    <xsl:value-of select="*[local-name()='media_type']/*[local-name()='terminology_id']/*[local-name()='value']"/>
                </value>
            </terminology_id>
            <code_string>
                <xsl:value-of select="*[local-name()='media_type']/*[local-name()='code_string']"/>
            </code_string>
        </media_type>
        <size>
            <xsl:value-of select="*[local-name()='size']"/>
        </size>
    </xsl:template>
    
    <xsl:template match="*[@*='oe:DV_PARSABLE']">
        
        <value>
            <xsl:value-of select="*[local-name()='value']"/>
        </value>
        <formalism>
            <xsl:value-of select="*[local-name()='formalism']"/>
        </formalism>
    </xsl:template>
    
    <xsl:template match="*[@*='oe:DV_URI']">
        
        <value>
            <xsl:value-of select="*[local-name()='value']"/>
        </value>
    </xsl:template>
     
    <xsl:template match="*[local-name()='normal_range']">
        <normal_range>
            <xsl:if test="*[local-name()='lower']">
                <lower>
                    <xsl:attribute name="xsi:type">
                        <!-- sb 06/03/08 [EHR-533] -->
                        <xsl:variable name="type">
                            <xsl:value-of select="*[local-name()='lower']/@xsi:type"/>
                            <xsl:value-of select="*[local-name()='lower']/@type"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="contains($type, 'oe:')"><xsl:value-of select="substring-after($type, 'oe:')"/></xsl:when>
                            <xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <magnitude>
                        <xsl:value-of select="*[local-name()='lower']/*[local-name()='magnitude']"/>
                    </magnitude>
                    <units>
                        <xsl:value-of select="*[local-name()='lower']/*[local-name()='units']"/>
                    </units>
                </lower>
            </xsl:if>
            <xsl:if test="*[local-name()='upper']">
                <upper>
                    <xsl:attribute name="xsi:type">
                        <!-- sb 06/03/08 [EHR-533] -->
                        <xsl:variable name="type">
                            <xsl:value-of select="*[local-name()='upper']/@xsi:type"/>
                            <xsl:value-of select="*[local-name()='upper']/@type"/>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="contains($type, 'oe:')"><xsl:value-of select="substring-after($type, 'oe:')"/></xsl:when>
                            <xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <magnitude>
                        <xsl:value-of select="*[local-name()='upper']/*[local-name()='magnitude']"/>
                    </magnitude>
                    <units>
                        <xsl:value-of select="*[local-name()='upper']/*[local-name()='units']"/>
                    </units>
                </upper>
            </xsl:if>
            <xsl:if test="*[local-name()='lower_included']">
                <lower_included>
                    <xsl:value-of select="*[local-name()='lower_included']"/>
                </lower_included>
            </xsl:if>
            <xsl:if test="*[local-name()='upper_included']">
                <upper_included>
                    <xsl:value-of select="*[local-name()='upper_included']"/>
                </upper_included>
            </xsl:if>
            <lower_unbounded>
                <xsl:value-of select="*[local-name()='lower_unbounded']"/>
            </lower_unbounded>
            <upper_unbounded>
                <xsl:value-of select="*[local-name()='upper_unbounded']"/>
            </upper_unbounded>
        </normal_range>
    </xsl:template>
    
    <xsl:template match="*[local-name()='other_reference_ranges']">
        <other_reference_ranges>
            <meaning>
                <xsl:value-of select="*[local-name()='meaning']"/>
            </meaning>
            <range>
                <xsl:if test="*[local-name()='range']/*[local-name()='lower']">
                    <lower>
                        <xsl:attribute name="xsi:type">
                            <!-- sb 06/03/08 [EHR-533] -->
                            <xsl:variable name="type">
                                <xsl:value-of select="*[local-name()='range']/*[local-name()='lower']/@xsi:type"/>
                                <xsl:value-of select="*[local-name()='range']/*[local-name()='lower']/@type"/>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="contains($type, 'oe:')"><xsl:value-of select="substring-after($type, 'oe:')"/></xsl:when>
                                <xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
                            </xsl:choose>
                            </xsl:attribute>
                        <magnitude>
                            <xsl:value-of select="*[local-name()='range']/*[local-name()='lower']/*[local-name()='magnitude']"/>
                        </magnitude>
                        <units>
                            <xsl:value-of select="*[local-name()='range']/*[local-name()='lower']/*[local-name()='units']"/>
                        </units>
                    </lower>
                </xsl:if>
                <xsl:if test="*[local-name()='range']/*[local-name()='upper']">
                        <upper>
                        <xsl:attribute name="xsi:type">
                            <!-- sb 06/03/08 [EHR-533] -->
                            <xsl:variable name="type">
                                <xsl:value-of select="*[local-name()='range']/*[local-name()='upper']/@xsi:type"/>
                                <xsl:value-of select="*[local-name()='range']/*[local-name()='upper']/@type"/>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="contains($type, 'oe:')"><xsl:value-of select="substring-after($type, 'oe:')"/></xsl:when>
                                <xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <magnitude>
                            <xsl:value-of select="*[local-name()='range']/*[local-name()='upper']/*[local-name()='magnitude']"/>
                        </magnitude>
                        <units>
                            <xsl:value-of select="*[local-name()='range']/*[local-name()='upper']/*[local-name()='units']"/>
                        </units>                
                        </upper>
                </xsl:if>
                <xsl:if test="*[local-name()='range']/*[local-name()='lower_included']">
                    <lower_included>
                        <xsl:value-of select="*[local-name()='range']/*[local-name()='lower_included']"/>
                    </lower_included>
                </xsl:if>
                <xsl:if test="*[local-name()='range']/*[local-name()='upper_included']">
                    <upper_included>
                        <xsl:value-of select="*[local-name()='range']/*[local-name()='upper_included']"/>
                    </upper_included>
                </xsl:if>
                <lower_unbounded>
                    <xsl:value-of select="*[local-name()='range']/*[local-name()='lower_unbounded']"/>
                </lower_unbounded>
                <upper_unbounded>
                    <xsl:value-of select="*[local-name()='range']/*[local-name()='upper_unbounded']"/>
            </upper_unbounded>
            </range>
        </other_reference_ranges>
    </xsl:template>
     
    <!-- sb: added 25/02/08 to support only codedText RM attributes where the xsi:type is not required as the type is already assumed from the openEHR schema -->
    <xsl:template name="CODED_TEXT_RM_ATTRIBUTE">
        <xsl:param name="currNode"/>
        
        <value>
            <xsl:value-of select="$currNode/*[local-name()='value']"/>
        </value>
        <xsl:call-template name="mappings">
            <xsl:with-param name="curr-node" select="$currNode"/>
        </xsl:call-template>
        
        <defining_code>
            <terminology_id>
                <value>
                    <xsl:value-of select="$currNode/*[local-name()='defining_code']/*[local-name()='terminology_id']/*[local-name()='value']"/>
                </value>
            </terminology_id>
            <code_string>
                <xsl:value-of select="$currNode/*[local-name()='defining_code']/*[local-name()='code_string']"/>
            </code_string>
        </defining_code>
    </xsl:template>
     
    <xsl:template name="CODE_PHRASE">
        <xsl:param name="currNode"/>
        <terminology_id>
            <xsl:for-each select="$currNode/*">
                <xsl:if test="local-name()='terminology_id'">
                    <value><xsl:value-of select="./*"/></value>
                </xsl:if>
            </xsl:for-each>
        </terminology_id>
        <code_string><xsl:value-of select="$currNode/*[local-name()='code_string']"/></code_string>
    </xsl:template>
    
    <xsl:template name="TEXT">
        <xsl:param name="currNode"/>
        
        <xsl:choose>
            <xsl:when test="$currNode/*[local-name()='defining_code']">
                <xsl:attribute name="xsi:type">DV_CODED_TEXT</xsl:attribute>
            </xsl:when>
        </xsl:choose>
        
        <value>
            <xsl:value-of select="$currNode/*[local-name()='value']/text()"/>
        </value>
        
        <xsl:call-template name="mappings">
            <xsl:with-param name="curr-node" select="$currNode"/>
        </xsl:call-template>
        
        <!-- if DV_CODED name -->
        <xsl:choose>
            <xsl:when test="$currNode/*[local-name()='defining_code']">
                <defining_code>
                    <terminology_id>
                        <value>
                            <xsl:value-of select="$currNode/*[local-name()='defining_code']/*[local-name()='terminology_id']/*[local-name()='value']/text()"/>
                        </value>
                    </terminology_id>
                    <code_string>
                        <xsl:value-of select="$currNode/*[local-name()='defining_code']/*[local-name()='code_string']/text()"/>
                    </code_string>
                </defining_code>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="TEXTV2">
        <xsl:param name="currNode"/>
        
        <xsl:if test="$currNode/@nameCode">
            <xsl:attribute name="xsi:type">DV_CODED_TEXT</xsl:attribute>
        </xsl:if>
        
        <value>
            <xsl:choose>
                <xsl:when test="count($currNode/following-sibling::node())>0 or count($currNode/preceding-sibling::node())>0">
                    <xsl:variable name="precedingSiblingDuplicate" select="count($currNode/preceding-sibling::node()[@name=$currNode/@name])"/>
                    <xsl:choose>                    
                        <xsl:when test="$precedingSiblingDuplicate>=1">
                            <xsl:value-of select="concat($currNode/@name, ' ', $precedingSiblingDuplicate)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$currNode/@name"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$currNode/@name"/>
                </xsl:otherwise>
            </xsl:choose>
        </value>
        
        <!-- TODO awaiting HF's response re. missing match, purpose and target values for mappings. -->
        <xsl:call-template name="mappingsV2">
            <xsl:with-param name="nameMappings" select="$currNode/@nameMappings"/>
        </xsl:call-template>
        
        <!-- if DV_CODED name -->
        <xsl:choose>
            <xsl:when test="$currNode/@nameCode">
                <defining_code>
                    <terminology_id>
                        <value>
                            <xsl:value-of select="$currNode/@nameTerminology"/>
                        </value>
                    </terminology_id>
                    <code_string>
                        <xsl:value-of select="$currNode/@nameCode"/>
                    </code_string>
                </defining_code>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="PARTY_PROXY">
        <xsl:param name="currNode"/>
        
        <xsl:choose>
            <xsl:when test="$currNode/@xsi:type='oe:PARTY_IDENTIFIED' or $currNode/oe:name!='' or $currNode/oe:identifiers!=''">
                <!--<xsl:attribute name="xsi:type">PARTY_IDENTIFIED</xsl:attribute>
                <xsl:call-template name="generate-external-ref">
                    <xsl:with-param name="currNode" select="$currNode"/>
                </xsl:call-template>
                <xsl:if test="$currNode/*[local-name()='name']">
                    <name>
                        <xsl:value-of select="$currNode/*[local-name()='name']/text()"/>
                    </name>
                </xsl:if>
                    <xsl:for-each select="$currNode/*[local-name()='identifiers']">
                        <identifiers>
                            <xsl:call-template name="DV_IDENTIFIER"/>
                         </identifiers>
                         </xsl:for-each>-->
                <xsl:call-template name="PARTY_IDENTIFIED">
                    <xsl:with-param name="currNode" select="$currNode"/>
                    <!--<xsl:with-param name="fixedType" select="true()"/>-->
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$currNode/@xsi:type='oe:PARTY_SELF' or $currNode/oe:external_ref">
                <xsl:attribute name="xsi:type">PARTY_SELF</xsl:attribute>
                <xsl:call-template name="generate-external-ref">
                    <xsl:with-param name="currNode" select="$currNode"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="count($currNode/@xsi:type)=0">
                <xsl:attribute name="xsi:type">PARTY_SELF</xsl:attribute>
                <xsl:call-template name="generate-external-ref">
                    <xsl:with-param name="currNode" select="$currNode"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="OBJECT_REF">
        <xsl:param name="currNode" select="."/>
        
        <id>
            <xsl:variable name="type" select="$currNode/oe:id/@xsi:type"/>
            <xsl:choose>
                <xsl:when test="substring-before($type, ':')!='' ">
                    <xsl:attribute name="xsi:type"><xsl:value-of select="substring-after($type, ':')"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="xsi:type"><xsl:value-of select="$type"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
                        
            <value><xsl:value-of select="$currNode/oe:id/oe:value/text()"/></value>
            <xsl:if test="$currNode/oe:id/oe:scheme/text() !='' ">
                <scheme><xsl:value-of select="$currNode/oe:id/oe:scheme/text()"/></scheme>
            </xsl:if>
        </id>
        <namespace><xsl:value-of select="$currNode/oe:namespace/text()"/></namespace>
        <type><xsl:value-of select="$currNode/oe:type/text()"/></type>
    </xsl:template>

    <xsl:template name="generate-external-ref">
        <xsl:param name="currNode"/>
        
        <!--<xsl:if test="$currNode/*[local-name()='external_ref']/*[local-name()='id']/*[local-name()='value']/text()!=''
            and $currNode/*[local-name()='external_ref']/*[local-name()='namespace']/text()!=''
            and $currNode/*[local-name()='external_ref']/*[local-name()='id']/*[local-name()='scheme']/text()!=''
            and $currNode/*[local-name()='external_ref']/*[local-name()='type']/text()!=''">--><!-- PARTY_REF inherited from PARTY_PROXY -->
        <xsl:if test="$currNode/oe:external_ref">
            <external_ref>
                <!--<id xsi:type="GENERIC_ID">
                    <value><xsl:value-of select="$currNode/*[local-name()='external_ref']/*[local-name()='id']/*[local-name()='value']/text()"/></value>
                    <scheme><xsl:value-of select="$currNode/*[local-name()='external_ref']/*[local-name()='id']/*[local-name()='scheme']/text()"/></scheme>
                </id>
                <namespace><xsl:value-of select="$currNode/*[local-name()='external_ref']/*[local-name()='namespace']/text()"/></namespace>
                <type><xsl:value-of select="$currNode/*[local-name()='external_ref']/*[local-name()='type']/text()"/></type>-->
                <xsl:call-template name="OBJECT_REF">
                    <xsl:with-param name="currNode" select="$currNode/oe:external_ref"/>
                </xsl:call-template>
            </external_ref>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="PARTY_IDENTIFIED">
        <xsl:param name="fixedType">false</xsl:param><!-- if the type='PARTY_IDENTIFIED' is already fixed and assumed from the RM then = 'true'' -->
        <xsl:param name="currNode" select="."/>

        <xsl:if test="$fixedType!='true'"><!-- need to specify type explicitly if it's not from the RM and it is not fixed -->
            <xsl:attribute name="xsi:type">PARTY_IDENTIFIED</xsl:attribute>
        </xsl:if>
        <xsl:call-template name="generate-external-ref">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
        <xsl:if test="$currNode/*[local-name()='name']">
            <name>
                <xsl:value-of select="$currNode/*[local-name()='name']/text()"/>
            </name>
        </xsl:if>
        <xsl:for-each select="$currNode/*[local-name()='identifiers']">
            <identifiers>
                <xsl:call-template name="DV_IDENTIFIER"/>
             </identifiers>
         </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="PARTICIPATION">
        <xsl:param name="currNode"/>
        
        <xsl:attribute name="xsi:type">PARTICIPATION</xsl:attribute>
        <function>
            <xsl:call-template name="TEXT">
                <xsl:with-param name="currNode" select="$currNode/*[local-name()='function']"/>
            </xsl:call-template>
        </function>
        <performer>
            <xsl:call-template name="PARTY_PROXY">
                <xsl:with-param name="currNode" select="$currNode/*[local-name()='performer']"/>
            </xsl:call-template>
        </performer>
        <mode>
            <xsl:call-template name="CODED_TEXT">
                <xsl:with-param name="currNode" select="$currNode/*[local-name()='mode']"/>
            </xsl:call-template>
        </mode>
        <xsl:if test="$currNode/*[local-name()='time']">
            <time>
                <xsl:apply-templates select="$currNode/*[local-name()='time' and @xsi:type]">
                    <xsl:with-param name="currNode" select="$currNode/*[local-name()='time' and @xsi:type]"/>
                </xsl:apply-templates>
            </time>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="formatName">
        <xsl:param name="nodeName"/>
        
        <xsl:choose>
            <xsl:when test="contains($nodeName, '_')">
                <xsl:call-template name="formatName">
                    <xsl:with-param name="nodeName" select="substring-before($nodeName, '_')"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
                <xsl:call-template name="formatName">
                    <xsl:with-param name="nodeName" select="substring-after($nodeName, '_')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($nodeName, '-')">
                <xsl:call-template name="formatName">
                    <xsl:with-param name="nodeName" select="substring-before($nodeName, '-')"/>
                </xsl:call-template>
                <xsl:text>/</xsl:text>
                <xsl:call-template name="formatName">
                    <xsl:with-param name="nodeName" select="substring-after($nodeName, '-')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$nodeName" disable-output-escaping="yes"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="ASSUMED_ELEMENT">
        <xsl:param name="currNode"/>
                
        <xsl:attribute name="archetype_node_id">
            <xsl:value-of select="$currNode/@archetype_node_id"/>
        </xsl:attribute>
        
        <xsl:call-template name="generate-name-any-links-and-any-archetype-details">
            <xsl:with-param name="currNode" select="$currNode"/>
        </xsl:call-template>
        
        <xsl:choose>
            <xsl:when test="$currNode/*[local-name()='null_flavour']">
            <null_flavour>
                <value><xsl:value-of select="$currNode/*[local-name()='null_flavour']/*[local-name()='value']"/></value>
                <defining_code>
                    <terminology_id>
                        <value>openehr</value>
                    </terminology_id>
                    <code_string><xsl:value-of select="$currNode/*[local-name()='null_flavour']/*[local-name()='defining_code']/*[local-name()='code_string']"/></code_string>
                </defining_code>
            </null_flavour>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$currNode/*">
                    <xsl:if test="contains(local-name(), 'value')">
                    <value>
                    <xsl:choose>
                        <!-- no xsi:type specified because it has been constrained in the TDS - usually if it is a CODED_TEXT -->
                        <xsl:when test="*[local-name()='defining_code']">
                            <!-- CODED_TEXT -->
                            <xsl:call-template name="CODED_TEXT">
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <!-- sb added 05/03/08 TMP-461 -->
                        <xsl:when test="*[local-name()='defining_code']">
                            <!-- CODED_TEXT -->
                            <xsl:call-template name="CODED_TEXT">
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <!-- sb. end added -->
                        <!-- sb: added 05/02/08 to support TDD 'valueType' attribute -->
                        <!-- DV_TEXT only -->
                        <xsl:when test="../@valueType='DV_TEXT' and not(*[local-name()='defining_code'])">
                            <xsl:call-template name="DV_TEXT">
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <!-- DV_DATE_TIME -->
                        <xsl:when test="../@valueType='DV_DATE_TIME'">
                            <xsl:call-template name="DV_DATE_TIME">
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="../@valueType='DATA_VALUE'">
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <!-- ADDED 27/08/08 -->
                        <!-- DV_ORDINAL -->
                        <xsl:when test="../@valueType='DV_ORDINAL'">
                            <xsl:call-template name="DV_ORDINAL">
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <!-- DV_QUANTITY (13/08/08) -->
                        <xsl:when test="../@valueType='DV_QUANTITY'">                         
                            <xsl:call-template name="DV_QUANTITY">
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <!-- DV_BOOLEAN (25/08/08) -->
                        <xsl:when test="../@valueType='DV_BOOLEAN'">                         
                            <xsl:call-template name="DV_BOOLEAN">
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <!-- DV_COUNT (25/08/08) -->
                        <xsl:when test="../@valueType='DV_COUNT'">                         
                            <xsl:call-template name="DV_COUNT">
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <!-- DV_DURATION(25/08/08) -->
                        <xsl:when test="../@valueType='DV_DURATION'">                         
                            <xsl:call-template name="DV_DURATION">
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <!-- DV_DATE(25/08/08) -->
                        <xsl:when test="../@valueType='DV_DATE'">
                            <xsl:call-template name="DV_DATE">
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <!-- DV_TIME(25/08/08) -->
                        <xsl:when test="../@valueType='DV_TIME'">
                            <xsl:call-template name="DV_TIME">
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <!-- END ADDED 27/08/08 -->
                        <xsl:otherwise>                            
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:apply-templates>
                        </xsl:otherwise>
                    </xsl:choose>
                </value>
                    </xsl:if>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="mappings">
        <xsl:param name="curr-node"/>
        
        <xsl:for-each select="$curr-node[*[local-name()='mappings']]">
            <mappings>
                <match><xsl:value-of select="*[local-name()='mappings']/*[local-name()='match']"/></match>
                <xsl:if test="*[local-name()='mappings']/*[local-name()='purpose']/*[local-name()='value']/text()!=''">
                <purpose>
                    <value><xsl:value-of select="*[local-name()='mappings']/*[local-name()='purpose']/*[local-name()='value']"/></value>
                    <defining_code>
                        <terminology_id>
                            <value>openehr</value>
                        </terminology_id>
                        <code_string><xsl:value-of select="*[local-name()='mappings']/*[local-name()='purpose']/*[local-name()='defining_code']/*[local-name()='code_string']"/></code_string>
                    </defining_code>
                </purpose>
                </xsl:if>
                <target>
                    <terminology_id>
                        <value><xsl:value-of select="*[local-name()='mappings']/*[local-name()='target']/*[local-name()='terminology_id']/*[local-name()='value']"/></value>
                    </terminology_id>
                    <code_string><xsl:value-of select="*[local-name()='mappings']/*[local-name()='target']/*[local-name()='code_string']"/></code_string>
                </target>
            </mappings>
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template name="mappingsV2">
        <xsl:param name="nameMappings"/>
        
        <!-- comma delimited list of code phrases, e.g. LOINC::17234-1,SNOMEDCT::8236782901 -->
        <!-- TODO <xsl:choose>
            <xsl:when test="contains($nameMappings, ',')">
                <mappings>
                    <match><xsl:value-of select="*[local-name()='mappings']/*[local-name()='match']"/></match>
                    <xsl:if test="*[local-name()='mappings']/*[local-name()='purpose']/*[local-name()='value']/text()!=''">
                    <purpose>
                        <value><xsl:value-of select="*[local-name()='mappings']/*[local-name()='purpose']/*[local-name()='value']"/></value>
                        <defining_code>
                            <terminology_id>
                                <value>openehr</value>
                            </terminology_id>
                            <code_string><xsl:value-of select="*[local-name()='mappings']/*[local-name()='purpose']/*[local-name()='defining_code']/*[local-name()='code_string']"/></code_string>
                        </defining_code>
                    </purpose>
                    </xsl:if>
                    <target>
                        <terminology_id>
                            <value><xsl:value-of select="*[local-name()='mappings']/*[local-name()='target']/*[local-name()='terminology_id']/*[local-name()='value']"/></value>
                        </terminology_id>
                        <code_string><xsl:value-of select="*[local-name()='mappings']/*[local-name()='target']/*[local-name()='code_string']"/></code_string>
                    </target>
                </mappings>    
            </xsl:when>
        </xsl:choose>-->
        
    </xsl:template>
    
    <xsl:template name="generate-name-any-links-and-any-archetype-details">
        <xsl:param name="currNode"/>
        
        <name>
            <xsl:choose>
                <xsl:when test="$currNode/@name">
                    <xsl:call-template name="TEXTV2"><!-- original TDS format -->
                        <xsl:with-param name="currNode" select="$currNode"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="TEXT"><!-- original TDS format -->
                <xsl:with-param name="currNode" select="$currNode/*[local-name()='name']"/>
            </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </name>
        <xsl:apply-templates select="$currNode/*[local-name()='links']"/>
        <!--<xsl:if test="@template_id">-->
        <xsl:if test="not(starts-with(@archetype_node_id, 'at'))">
            <xsl:call-template name="archetype_details">
                <xsl:with-param name="archetype_node_id" select="$currNode/@archetype_node_id"/>
                <xsl:with-param name="template_id" select="$currNode/@template_id"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:apply-templates select="$currNode/*[local-name()='feeder_audit']"/>
        
    </xsl:template>
    
</xsl:stylesheet>
