<?xml version="1.0" encoding="UTF-8"?>
<!--  
  $LastChangedDate$
  Version: 2.4
  $Revision$
  TODO: Implement any constraints on 'normal_range' and other_reference_ranges (DV_ORDERED) values.
  TODO: Test transform with OPT that has default values specified
  
  Change descriptions:
    - 21/10/13  Added back INSTRUCTION/expiry_time that had been commented out
    - 30/07/13: Added back in support for definitions attribute in ACTION that had been accidentally removed 
    - 15/05/13: Added feeder_audit to ENTRY classes 
    - 22/03/11: removed condition to ensure workflow_id always exists
    - 20/12/10: Add feeder_audit element into COMPOSITION.
    - 28/10/10: TMP-1279 C_CODE_REFERENCE is now type used on external defining code constraint (not CONSTRAINT_REF).
    - 29/04/10: TMP-1234 Represent element value and null_flavour as mandatory choice. This meant I removed
                  all minOccurs=0 attributes on all elements inside this choice as they're no longer required for the 
                  optionality between value and null_flavour.
    - 16/04/10: TMP-1233 Add correct maxOccurs and/or minOccurs to the event xs:choice (in OBSERVATIONs)
    - 07/04/10: TMP-1223 "Unfix" the territory code from AU so it is default, and only provide default when
                  input parameter default-territory-code is set.
    - 09/09/09: Now outputs 'helper' comments in the enumeration of values for DV_ORDINAL showing the symbol
                  value and symbol code_string that correspond to a specific dv_ordinal.value).
                  Note: This is particularly useful for when 'mappings' has to be outputted in the 
                  DV_ORDINAL.symbol (DV_CODED_TEXT attribute).
    - 14/08/09: Corrected 'objectElementAttributes' (checks if there is only 1 code_list value before 
                  applying name constraint for DV_CODED_TEXT name).
    - 12/08/09: Fixed bug in 'objectElementAttributes'; now gets the name constraint for a DV_CODED_TEXT name.
    - 28/07/09: Corrected territory code string from lower case 'au' to upper case 'AU' to be valid instance.
                Corrected encoding terminology ID so that it's now 'IANA_character-sets' instead of 'IANA'.
                Corrected encoding code string from lower case 'utf-8' to upper case 'UTF-8'.
    - 08/07/09: TMP-1081 Modify TDS builder so that the HISTORY.origin is optional rather than mandatory.
    - 22/06/09: TMP-1063 Fixed CLUSTER that is an ARCHETYPE_ROOT so that it's archetype node ID is the 
                  archetype ID not the node_id 'at0000'.
    - 18/06/09: TMP-1061 Added helper comments for each codes_string enumeration that say what the 
                  corresponding value is in the TDS.
    - 17/06/09: TMP-1054 Changed the TDS generation to make the template_id required.
    - 10/06/09: The 'transition' and 'careflow_step' elements are now in the ISM_TRANSITION (was commented
                  out previously for NEHTA).
    - 24/05/09: Added optional 'links' element (at the moment, I've added these wherever a 'uid' was 
                  outputted as this is also part of LOCATABLE) i.e. COMPOSITION, ADMIN_ENTRY, OBSERVATION,
                  EVALUATION, INSTRUCTION, ACTION, ACTIVITY. 
    - 23/05/09: Added optional 'alternate_text', 'uri' and mandatory 'size' for DV_MULTIMEDIA.
                Removed mandatory 'instruction_id' and 'activity_id' element in ACTION.
    - 18/05/09: Added check if 'valueType' xml attribute values is enumerated (ie. for a constrained set of
                  choice datatypes), then the 'valueType' XML attribute is *required* (it must be filled in
                  in the TDD).  This is because it is not a 'fixed' value so the valueType cannot be obtained
                  from the schema by EhrAdapter to automatically populate. So in summary, if 'valueType'
                  has one possible value, then it is fixed (not required in the TDD), otherwise if it is 
                  enumerated, then must output 'use="required"' xml attribute.
    - 17/05/09: Added optional elements for the DV_QUANTIFIED and DV_ORDERED types from openEHR RM (as 
                  requested by Sam).
                Fixed bug to do with adding xml attributes (minOccurs) in incorrect order in 
                  DV_INTERVAL.lower/upper elements.
    - 14/05/09: TMP-1044 Reimplemented archetype slot handling (now supports both unnamed and named slots and
                  gets the occurrences from the ARCHETYPE_SLOT in the OPT).
                  ***Warning***: The TDS does not care if the element names in a sequence are unique or not. 
                Modified 'occurrences' handling so that it doesn't output 'maxOccurs=1' as this is the 
                  default in XSD if it's not specified.
    - 04/05/09: TMP-1038 Add 'fixed_is_required' global parameter. By default, this should be 'false' 
                  (i.e. not output the 'fixed' attribute in the TDS).
                TMP-629 Added 'tds-root-namespace' global parameter.  By default, this is
                  'http://schemas.oceanehr.com/templates'.
    - 22/04/09: TMP-1033 Removed 'use' node attribute with 'required' value. 
    - 07/04/09: TMP-1020 Fixed DV_INTERVAL output so that it has optional 'lower', 'upper', 'lower_included',
                  'upper_included' and mandatory 'lower/upper_unbounded' XML elements.
                Also outputted comments in the TDS output for DV_INTERVAL to help clarify the ambiguity of 
                  the correct use of the above DV_INTERVAL XML elements.
                  Note: there is still the issue to be considered about any constraints that might be placed
                  on the above attributes in the archetype when/if they are to be supported in future.
                  If there are requirements for such constraints then need to think about how they can be
                  constrained and how it is then represented in the TDS (see JIRA for issue).
    - 03/04/09: Corrected type in EVENT_CONTEXT.health_care_facility.
    - 16/03/09: Changed COMPOSITION.context part to generate context schema definition for all event 
                  composition regardless whether the OPT has any constraints on other_context or not.
    - 04/03/09: Added missing 'value' xml element in constrained 'math_function' which is a DV_CODED_TEXT.
    - 03/03/09: Changed order of 'state' and 'data' in EVENT.
                Removed container 'description' xml element from ACTION and ACTIVITY, so it now aligns with
                  the TDO (as agreed with HKF).
    - 02/03/09: Added support for 'mappings' for element names.
    - 25/02/09: Corrected maxOccurs value for 'mappings' to be 'unbounded' & changed sequence order in which
                  'mappings' occurs to be before 'defining_code' for DV_CODED_TEXT to be consistent with 
                  openEHR schemas.
    - 24/02/09: TMP-964 EVENT data structure for HISTORY now implemented using 'xs:choice' when it can either
                  be POINT_EVENT or INTERVAL_EVENT  (i.e. there is no constraint on the type of EVENT). 
                  Currently, the TDS represents the above using xs:restriction on the type of EVENT, but does
                  not support mandatory 'width' and 'math_function' attributes if it is an INTERVAL_EVENT. 
    - 20/02/09: TMP-964 Fixed incorrect regex pattern for DV_DURATION constraints.
                Fixed transform error where the attribute was created after the child node for 'null_flavour'
                  creation.
                TMP-962 was due to the OPT instance using both uppercase and lowercase rm_type_name values 
                  for 'string' (logged this issue TMP-963), but I now convert the value to uppercase before
                  doing the comparison in the xpath.
    - 19/02/09: TMP-961 Added optional 'mappings' XML element in the TDS for DV_TEXT with constrained set of
                  values.
                TMP-962 Fix incorrect xpath in 'objectElementAttributes' & 
                  'constructTextAndCodedTextElementValue' XSL templates (rm_attribute_name 'string' should be
                  in upper case).
                Added 'minOccurs' = 0 attributes for 'mappings'.
    - 18/02/09: TMP-957 Added optional 'mappings' XML element for DV_CODED_TEXT with constrained 
                  'defining_code'.
    - 06/02/09: TMP-917 Implement any templated constraints on null_flavour value set.
    - 21/11/08: Removed 'activities' XML element again as this is just a container.
                TMP-842 Updated to use the XML lookup file for replacement of invalid characters in XML 
                  element names.
    - 14/11/08: TMP-839 Replaced normal brackets & curly brackets with underscores instead of just removing
                  them; and removed any asterisks to create valid XML element names.
    - 07/11/08: Support multiple value children objects of type DV_CODED_TEXT.
    - 06/11/08: Prevent having min/maxOccurs XML attributes on the TDS root (i.e. defaults to 1..1).
    - 02/10/08: Added check to ensure DV_QUANTITY choice data type is included as well for multiple choice 
                  data types when there is no multiple C_QUANTITY_ITEMs.
                Fixed bug in 'constructElementName' XSL template where DV_CODED_TEXT name defining_code was
                  optional for item using C_CODE_REFERENCE. It is now set to mandatory.
    - 01/10/08: Added check and apply value constraints in ELEMENT XSL template for other datatypes 
                  (i.e. NOT dv_quantity or dv_interval).
    - 29/08/08: Replaced '&gt;' and '&lt;' chars in element names with words.
    - 21/08/08: Added DV_QUANTIFIED.magnitude_status to all DV_QUANTIFIED sub-datatypes as optional element.
                Fixed bug in DV_TEXT constraint - is now within complexType, sequence & value element.
    - 20/08/08: Implemented constraints on DV_TEXT list of text values.
                Minor change: simplified XSD constraint on 'code_string' values to fixed value if there is
                  only 1 value otherwise uses enumeration.
                Now applies constraint on EVENT type.
                Width and Math_function attributes are mandatory in the RM so now outputs with or without
                  constraints if it is an INTERVAL_EVENT.
                Fixed bug in 'valueType' attribute value.
    - 14/08/08: Revised DV_COUNT template.
                Added UNconstrained 'null_flavour' as discussed with Heath & Hugh (esp for CCV project).
                Added check for constraint on DV_QUANTITY.precision to be integral.
    - 13/08/08: HISTORY.origin element must be mandatory.
    - 11/08/08: XPath bug fixed in constructTextAndCodedTextElementValue xsl template.
    - 08/08/08: Property unit data now uses the units and formats that to valid XML element name from the 
                  OPT rather than looking up external XML document (PropertyUnitData.xml).
    - 07/08/08: Implemented DV_QUANTITY.precision using xs:pattern on double.
                Property-unit lookup revised to handle '[unit]/[unit]' (ratio) type of unit individually if 
                  not already found as is in the xml document (applies to units such as {MASS/VOLUME}, etc).
    - 06/08/08: Fixed xpath bug in handling of single data type value. Needed to specify predicate where
                  rm_attribute_name='value' (and similarly for the 'valueType' of a single data type value).
    - 05/08/08: Fixed bug in handling DV_QUANTITY. If there are no constraints on magnitude and units, then
                  should still output them with no constraints.
    - 30/07/08: Reverted changes to the ITEM_STRUCTURE type xsl templates that is ARCHETYPE_ROOT
                  so that it has an element name (e.g. 'medication description' (ITEM_TREE)) with the
                  archetype_node_id = archetype_ID.  (i.e. similar to what's been done for CLUSTER and 
                  ELEMENT and other RM types that are archetype roots) (see xsl fragments within xml comments
                  marked as 'new').
    - 29/07/08: Template Data Slot now also outputs if a C_COMPLEX_OBJECT has no 'attributes' (or no 
                  archetype_slot specified). Tested with Ficha Clinica example where 'Urinal-Intestinal 
                  habits' section has no 'attributes').
                Added check if units string length is zero or not for DV_QUANTITY (otherwise it incorrectly 
                  outputs an XSL fixed attribute value of "" from the OPT). Tested with demo_dv_time.opt file.
                Changed ELEMENT (ARCHETYPE_ROOT) archetype_node_id value to the archetype_ID rather than 
                  'at0000' (atcode). HKF comment: no XSD should contain 'at0000' as an ID as this is the same
                  as the archetype ID itself.
    - 28/07/08: Removed unnecessary minOccurs and maxOccurs = 1 in some RM attributes as this is the default.
                Replaced '+' sign with the word 'plus' (e.g. in 'demo_dv_interval.oet' there is an element 
                  name called 'Archetype + path'.
                Fixed bug in DV_PROPORTION apply template where 'xs:enumeration' was incorrectly outputted as
                  an XML attribute value rather than an xml element.
    - 25/07/08: Changed COMPOSITION.category so it uses 'fixed' xslt attribute instead of enumeration.
                Changed EVENT.width/offset so it uses 'fixed' xslt attribute instead of enumeration.
                Ditto for C_QUANTITY_ITEM.unit constraint (there were two occurrences of this).
    - 22/07/08: ITEM_SINGLE completed.
                Added Template Data Slot handling in (OBSERVATION.HISTORY).EVENT.data and EVENT.state.
                Implemented OBSERVATION.state (Need to create a new archetype that has this and test it).
    - 21/07/08: Fixed all Data Structure types so that 'name' element no longer gets outputted.
                ITEM_SINGLE and ITEM_TABLE.
                Fixed bugs, including correction of archetypeRoot select node in the ITEM_TREE/ITEM_LIST 
                  archetype root XSL templates.
    - 18/07/08: Template Data Slot handling in relevant types and xsl templates.
                ITEM_SINGLE and ITEM_TABLE templates.
    - 17/07/08: Added removal of colon in element names...will need more generic solution to handle special
                  chars not allowable in xml element names in future (also need to consider different char 
                  sets for different languages).
    - 16/07/08: Added removal of curly brackets in element names.
    - 13/07/08: Fixed ELEMENT Archetype Root to now match non-archetype-root ELEMENT template [need
                  to test this though[ (n.b. Future fix: could consider just merging these two xsl templates 
                  to one with a different 'archetypeRoot' select node depending on whether or not this is of
                  type C_ARCHETYPE_ROOT or not).
                Fixed bug in CLUSTER (archetype Root) template: call to 'constructElementName' now selects 
                  current node ('.') instead of $archetypeRoot param.  Also removed the archetypeRoot 
                  paramater in this template.
                Fixed ELEMENT template to handle multiple datatypes with or without interval and with multiple
                  C_QUANTITY_ITEMs (this is now handled at this higher level template, otherwise if there is
                  only one C_QUANTITY_ITEM or no constraint then it is handled in a separate DV_QUANTITY 
                  template match template (tested with Medication List and Vital signs).
                Added DV_EHR_URI and DV_PARSABLE.
    - 10/07/08: TMP586 Finished implementing DV_IDENTIFIER.
                Fixed bug to do with 'value' element appearing multiple times and 'value' element in
                  DV_QUANTITY.
    - 07/07/08: TMP-586 Added catch for DV_IDENTIFIER (TODO: implement pattern constraints).
    - 03/07/08: TMP-586 Implemented DV_DURATION.
    - 02/07/08: Implemented 'LookupPropertyUnitDataByUnit' template to lookup the Property Unit (descriptive)
                  name from PropertyUnitData.xml document.  This gets used choice C_QUANTITY_ITEMs to generate
                  unique and meaningful xml element names (esp. to satisfy the XSD unique particle attribution
                  rule).
                Implemented 'formatPropertyUnitName' template to format the property unit name so that it is 
                  a valid XML element name.
                Fixed DV_MULTIMEDIA implementation and tested using Antenatal referral.
                Fixed EVENT.width and EVENT.math_function outputs.
                Fixed bug in DV_QUANTITY template (set disable-output-escaping to 'yes' and corrected 
                  xs:choice tag).
    - 19/06/08: Updated template data schema target namespace (removed '/' at end of URI).
    - 06/06/08: Implemented DV_DATE_TIME, DV_TIME, DV_DATE pattern constraint. 
                Implemented DV_MULTIMEDIA constraints.
    - 05/06/08: Fixed xpath bug in 'other_context' apply-templates (i.e. added 'item' and 'rows' to support 
                  these ITEM_STRUCTUREs).
    - 04/06/08: Implemented INTERVAL/POINT EVENT math_function and width/offset constraints.
                Implemented DV_INTERVAL and DV_COUNT apply templates.
                TMP-546 Added lower and upper case letter global variable for use in converting from upper
                   case to lower case:
                   * Especially for generating the xml element name for a data value from a multiple data type
                     choice constraint (e.g. the xml element names 'count_value' element and 
                     'interval_count_value' element for 'Dose' in Medication item tree).
                   * This uses the xslt 'translate' function instead of the 'lower-case' function as the
                     latter is not supported by .NET xslt engines.
                TMP-502 Finished implementing DV_PROPORTION constructor.
    - 28/04/08: TMP-546 SB implemented DV_INTERVAL<DV_???> constraints.
    - 11/04/08: TMP-502 SB implemented other DATA_VALUE constraints e.g. DV_QUANTITY, DV_PROPORTION.
    - 12/03/08: TMP-463 SB implemented any constraints placed on the action_archetype_id (PATTERN only at 
                  this stage).
    - 04/03/08: TMP-461 SB added new logic to handle text/codedText element names and element values.
    - 29/02/08: TMP-462 SB implemented
    - 27/02/08: TMP-458 SB added  fix in 'valueType' xml attribute to be enumerated when handling 'choice'
                  datatyped elements.
    - This transform contains all changes made according to TMP-383.
    - Modified ELEMENT template to handle ANY datatype (no datatype constrained) to have element 'value' as
        optional.
    - Fixed template_data_slot bug.
    - Fixed datatype bug in 'constructTextAttribute' xsl template - now correctly assigns datatype for the 
        element 'value' if it is DV_CODED_TEXT.
    - Fixed bug in replaceSpecialChars xsl template - now also removes any '?' chars from element names (for
        boolean datatyped elements in particular).
    
    Author: Ocean Informatics Pty Ltd  
    Notes: RM_Attributes mandatory or not are transformed if they exist in OPT.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:oe="http://schemas.openehr.org/v1"
    xmlns:prop="http://tempuri.org/PropertyUnits.xsd"
    xmlns:cm="http://oceaninformatics.com/CharacterMapping.xsd">

    <xsl:variable name="version">2.3</xsl:variable>   
    <xsl:variable name="revision">$Revision$</xsl:variable>   
    <xsl:variable name="lastChangedDate">$LastChangedDate$</xsl:variable>
	
	<!-- NOTE: Following two constants are used as metadata by external tools. Don't change unless you're changing the external tools as well! -->
    <xsl:variable name="outputFileExtension">xsd</xsl:variable>
    <xsl:variable name="targetLanguage">XML Schema</xsl:variable>
    
    <xsl:output  indent="yes"/>
    
    <!-- **INPUT PARAMETERS** -->
    <xsl:param name="character-map-xml-document-path">CharacterMapping.xml</xsl:param>
    <xsl:param name="fixed-is-required">false</xsl:param>
    <xsl:param name="tds-root-namespace">http://schemas.oceanehr.com/templates</xsl:param><!-- also default namespace -->
	<xsl:param name="default-territory-code"/><!-- will not specify default territory code in output schema unless this is set (LMT 7/Apr/2010) TMP-1223-->
    
    <!-- **GLOBAL VARIABLES** -->
    <!-- 'base' pattern used for double datatype in DV_QUANTITY.precision constraint -->
    <xsl:variable name="begin-double-base-pattern" xml:space="preserve">(\+|\-)?(0|[1-9][0-9]*)?(\.[0-9]{</xsl:variable>
    <xsl:variable name="end-double-base-pattern" xml:space="preserve">})?</xsl:variable>
    <!-- patter used for double datatype in DV_QUANTITY.precision constraint to be integral/whole only -->
    <xsl:variable name="integral-pattern">(\+|\-)?(0|[1-9][0-9]*)?</xsl:variable>
    <!-- used for lower/upper case conversion via 'translate' xslt function -->
    <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
        
    <!-- SCHEMA ROOT -->
    <xsl:template match="oe:template">
    	<xsl:comment>Generated using tds-default.xsl v<xsl:value-of select="$version"/> (<xsl:value-of select="$revision"/>)</xsl:comment>

        <xsl:variable name="declarations" select="concat(
            '&lt;xs:schema xmlns:oe=&quot;http://schemas.openehr.org/v1&quot; xmlns=&quot;', $tds-root-namespace, '&quot; 
            elementFormDefault=&quot;qualified&quot; targetNamespace=&quot;', $tds-root-namespace, '&quot;
            xmlns:xs=&quot;http://www.w3.org/2001/XMLSchema&quot;&gt;')"/>

        <xsl:value-of select="$declarations" disable-output-escaping="yes"/>

        <xsl:element name="xs:import">
            <xsl:attribute name="schemaLocation">Structure.xsd</xsl:attribute>
            <xsl:attribute name="namespace">http://schemas.openehr.org/v1</xsl:attribute>
        </xsl:element>

                  
                    <xsl:apply-templates select="oe:definition"/>
                        <!--<xsl:with-param name="archetypeRoot" select="oe:definition"/>
                    </xsl:apply-templates>-->
                               
        <xsl:text disable-output-escaping="yes">
            <!-- sb: removed 23/01/08 &lt;xs:simpleType name="extendedArchetypeNodeId"&gt;
            &lt;xs:restriction base="xs:string"&gt;
            &lt;xs:pattern value="([a-zA-Z][\w_]*-[\w][\w_]*-[\w][\w_]*\.[\w][\w_]*(-[\w][\w_]*)*\.v\d+[a-zA-Z]*(\.\d)*)|(at(0\.[0-9]{1,4}|[0-9]{4})(\.[0-9]{1,3})*)" /&gt;
            &lt;/xs:restriction&gt;
            &lt;/xs:simpleType&gt;-->
            &lt;/xs:schema&gt;</xsl:text>
    </xsl:template>
    <!-- end SCHEMA ROOT -->
         
    <!-- COMPOSITION match (must ALWAYS be a definition element of type C_ARCHETYPE_ROOT) -->
    <xsl:template match="*[oe:rm_type_name='COMPOSITION']">
        <xsl:param name="archetypeRoot" select="."/><!-- assume composition is an archetype root -->

        <xsl:element name="xs:element">
                    <xsl:call-template name="objectElementAttributes">
                        <xsl:with-param name="archetypeRoot" select="."/>
                        <xsl:with-param name="c_object" select="."/>
                    </xsl:call-template>
                    
                    <xsl:element name="xs:complexType">
                        <xsl:element name="xs:sequence">
                            
                            <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                            <xsl:call-template name="constructElementName">
                                <xsl:with-param name="archetypeRoot" select="."/>
                                <xsl:with-param name="element-name-context" select="."/>
                            </xsl:call-template>
                    
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">uid</xsl:attribute>
                        <xsl:attribute name="type">oe:UID_BASED_ID</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">1</xsl:attribute>
                    </xsl:element>

                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">links</xsl:attribute>
                        <xsl:attribute name="type">oe:LINK</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                    </xsl:element>

                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">feeder_audit</xsl:attribute>
                        <xsl:attribute name="type">oe:FEEDER_AUDIT</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                    </xsl:element>

                    <!-- sb note 23/01/08 this language in composition is the only language that can currently be obtained from the OPT -->
                    <xsl:call-template name="constructCodePhrase">
                        <xsl:with-param name="code-phrase-name">language</xsl:with-param>
                        <xsl:with-param name="terminology-id" select="../oe:language/oe:terminology_id/oe:value"/>
                        <xsl:with-param name="code-string" select="../oe:language/oe:code_string"/>
                    </xsl:call-template>
                    
                    <!-- sb: added 23/01/08 -->
                    <xsl:call-template name="constructTerritory"/>
  
        <!-- COMPOSITION.territory (note, this is not yet implemented in the OPT - may be a future requirement at this point) -->
        <xsl:if test="oe:attributes[oe:rm_attribute_name='territory']">
            <xsl:element name="xs:element">
                <xsl:attribute name="name">territory</xsl:attribute>
                <xsl:element name="xs:complexType">
                    <xsl:element name="xs:sequence">
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">terminology_id</xsl:attribute>
                            <xsl:element name="xs:complexType">
                                <xsl:element name="xs:sequence">
                                    <xsl:element name="xs:element">
                                        <xsl:attribute name="name">value</xsl:attribute>
                                        <xsl:attribute name="fixed">ISO_3166-1</xsl:attribute>
                                        <xsl:attribute name="type">xs:token</xsl:attribute>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">code_string</xsl:attribute>
                        	   <xsl:if test="$default-territory-code and $default-territory-code!=''"><xsl:attribute name="default"><xsl:value-of select="$default-territory-code"/></xsl:attribute></xsl:if>
                            <xsl:attribute name="type">xs:string</xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:if>

        <!-- COMPOSITION.category -->
        <xsl:element name="xs:element">
            <xsl:attribute name="name">category</xsl:attribute>
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">value</xsl:attribute>
                        <xsl:attribute name="type">xs:string</xsl:attribute>
                        <xsl:attribute name="fixed">
                            <xsl:choose>
                                <xsl:when test="oe:attributes[oe:rm_attribute_name='category']/oe:children/oe:attributes/oe:children[oe:code_list='433']">event</xsl:when>
                                <xsl:when test="oe:attributes[oe:rm_attribute_name='category']/oe:children/oe:attributes/oe:children[oe:code_list='431']">persistent</xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">defining_code</xsl:attribute>
                        <xsl:element name="xs:complexType">
                            <xsl:element name="xs:sequence">
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">terminology_id</xsl:attribute>
                                    <xsl:element name="xs:complexType">
                                        <xsl:element name="xs:sequence">
                                            <xsl:element name="xs:element">
                                                <xsl:attribute name="name">value</xsl:attribute>
                                                <xsl:attribute name="fixed">openehr</xsl:attribute>
                                                <xsl:attribute name="type">xs:token</xsl:attribute>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">code_string</xsl:attribute>
                                    <xsl:attribute name="fixed">
                                        <xsl:value-of select="oe:attributes[oe:rm_attribute_name='category']/oe:children/oe:attributes/oe:children/oe:code_list"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="type">xs:string</xsl:attribute>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>

        <!-- COMPOSITION.composer-->
        <xsl:element name="xs:element">
            <xsl:attribute name="name">composer</xsl:attribute>
            <xsl:attribute name="type">oe:PARTY_PROXY</xsl:attribute>
        </xsl:element>
        
        <!-- COMPOSITION.context-->
        <xsl:variable name="composition-context" select="oe:attributes[oe:rm_attribute_name='context']/oe:children[oe:rm_type_name='EVENT_CONTEXT']"/>
        <!-- CM: 16/03/09 need to generate schema definition for context even when the OPT doesn't have context constraints -->
       <!-- <xsl:if test="$composition-context and oe:attributes[oe:rm_attribute_name='category']/oe:children/oe:attributes/oe:children[oe:code_list='433']"> -->
        <xsl:if test="oe:attributes[oe:rm_attribute_name='category']/oe:children/oe:attributes/oe:children[oe:code_list='433']">
            <xsl:call-template name="eventContext">
                <xsl:with-param name="context-node" select="$composition-context"/>
                <xsl:with-param name="archetypeRoot" select="."/>
            </xsl:call-template>
        </xsl:if>
       
       <xsl:choose>
           <!-- contains 'attributes' xml elements -->
           <xsl:when test="count(oe:attributes)>0">
               
               <!-- now process only child nodes that are not ARCHETYPE_SLOTS -->
               <xsl:for-each select="oe:attributes[oe:rm_attribute_name='content']/oe:children">
                   <xsl:choose>
                       <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                           <xsl:apply-templates select=".">
                               <xsl:with-param name="archetypeRoot" select="."/>
                           </xsl:apply-templates>
                       </xsl:when>
                       <xsl:otherwise>
                           <xsl:apply-templates select=".">
                               <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                           </xsl:apply-templates>
                       </xsl:otherwise>
                   </xsl:choose>
               </xsl:for-each>
               
           </xsl:when>
           <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
           <xsl:otherwise>
               <xsl:call-template name="generate-archetype-slot">
                   <xsl:with-param name="currNode" select="."/>
                   <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
               </xsl:call-template>
           </xsl:otherwise>
       </xsl:choose>

                </xsl:element>
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">
                        <xsl:value-of select="oe:archetype_id/oe:value"/>
                    </xsl:attribute>
                    <xsl:attribute name="name">archetype_node_id</xsl:attribute>
                    <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed"><xsl:value-of select="oe:rm_type_name"/></xsl:attribute>
                    <xsl:attribute name="name">type</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
                <!-- sb:added 23/01/08 -->
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed"><xsl:value-of select="../oe:template_id/oe:value"/></xsl:attribute>
                    <xsl:attribute name="name">template_id</xsl:attribute>
                    <xsl:attribute name="use">required</xsl:attribute>
                </xsl:element>
                <!-- end added -->
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- end COMPOSITION match -->

    <!-- SECTION (C_COMPLEX_OBJECT or C_ARCHETYPE_ROOT) match -->
    <xsl:template match="*[(oe:rm_type_name='SECTION') and (@xsi:type='C_COMPLEX_OBJECT' or @xsi:type='C_ARCHETYPE_ROOT')]">
        <xsl:param name="archetypeRoot"/>
        
        <xsl:element name="xs:element">
            
            <xsl:call-template name="objectElementAttributes">
                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                <xsl:with-param name="c_object" select="."/>
            </xsl:call-template>
            
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    
                    <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                    <xsl:call-template name="constructElementName">
                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                        <xsl:with-param name="element-name-context" select="."/>
                    </xsl:call-template>
                    
                    <xsl:choose>
                        <!-- contains 'attributes' xml elements -->
                        <xsl:when test="count(oe:attributes)>0">
                            <!-- now process only child nodes -->
                            <xsl:for-each select="oe:attributes[oe:rm_attribute_name='items']/oe:children">
                                <xsl:choose>
                                    <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                        <xsl:apply-templates select=".">
                                            <xsl:with-param name="archetypeRoot" select="."/>
                                        </xsl:apply-templates>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select=".">
                                            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                        </xsl:apply-templates>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
                        <xsl:otherwise>
                            <xsl:call-template name="generate-archetype-slot">
                                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:element>
                
                <xsl:call-template name="archetypeNodeIdAttribute">
                    <xsl:with-param name="pathableNode" select="."/>
                </xsl:call-template>
                
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">SECTION</xsl:attribute>
                    <xsl:attribute name="name">type</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- end SECTION Archetype Root -->
    
    <!-- ARCHETYPE_SLOT match -->
    <xsl:template match="*[@xsi:type='ARCHETYPE_SLOT']">
        <xsl:param name="archetypeRoot"/>
        
        <xsl:call-template name="generate-archetype-slot">
            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
            <xsl:with-param name="currNode" select="."/>
        </xsl:call-template>
        
    </xsl:template>
    
    <!-- INSTRUCTION (C_COMPLEX_OBJECT or C_ARCHETYPE_ROOT) match -->
    <xsl:template match="*[(oe:rm_type_name='INSTRUCTION') and (@xsi:type='C_COMPLEX_OBJECT' or @xsi:type='C_ARCHETYPE_ROOT')]">
        <xsl:param name="archetypeRoot"/>
        
        <xsl:element name="xs:element">

            <!-- create element name attribute -->
            <xsl:call-template name="objectElementAttributes">
                <xsl:with-param name="archetypeRoot" select="."/>
                <xsl:with-param name="c_object" select="."/>
            </xsl:call-template>
            
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    
                    <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                    <xsl:call-template name="constructElementName">
                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                        <xsl:with-param name="element-name-context" select="."/>
                    </xsl:call-template>

                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">uid</xsl:attribute>
                        <xsl:attribute name="type">oe:UID_BASED_ID</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">1</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">links</xsl:attribute>
                        <xsl:attribute name="type">oe:LINK</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">feeder_audit</xsl:attribute>
                        <xsl:attribute name="type">oe:FEEDER_AUDIT</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:call-template name="entryAttributes">
                        <xsl:with-param name="archetypeRoot" select="."/>
                    </xsl:call-template>
                    <xsl:call-template name="careEntryAttributes">
                        <xsl:with-param name="archetypeRoot" select="."/>
                    </xsl:call-template>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">narrative</xsl:attribute>
                        <xsl:attribute name="type">oe:DV_TEXT</xsl:attribute>
                    </xsl:element>
                    
                     <xsl:element name="xs:element">
                        <xsl:attribute name="name">expiry_time</xsl:attribute>
                        <xsl:attribute name="type">oe:DV_DATE_TIME</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">1</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">wf_definition</xsl:attribute>
                        <xsl:attribute name="type">oe:DV_PARSABLE</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">1</xsl:attribute>
                    </xsl:element>

                    <xsl:choose>
                        <!-- contains 'attributes' xml elements -->
                        <xsl:when test="count(oe:attributes)>0">
                            
                            <!-- now process only child nodes -->
                            <!-- apply templates for activities -->
                            <xsl:for-each select="oe:attributes[oe:rm_attribute_name='activities']/oe:children">                            
                                <xsl:choose>
                                    <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                        <xsl:apply-templates select=".">
                                            <xsl:with-param name="archetypeRoot" select="."/>
                                        </xsl:apply-templates>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select=".">
                                            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                        </xsl:apply-templates>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
                        <xsl:otherwise>
                            <xsl:call-template name="generate-archetype-slot">
                                <xsl:with-param name="currNode" select="."/>
                                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:element>    
                
                <xsl:call-template name="archetypeNodeIdAttribute">
                    <xsl:with-param name="pathableNode" select="."/>
                </xsl:call-template>
                
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">INSTRUCTION</xsl:attribute>
                    <xsl:attribute name="name">type</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- end INSTRUCTION match -->
      
    <!-- EVENT_CONTEXT match (must ALWAYS be a children element) -->
    <xsl:template name="eventContext">
        <xsl:param name="context-node"/>
        <xsl:param name="archetypeRoot"/>
        
        <xsl:element name="xs:element">
            <xsl:attribute name="name">context</xsl:attribute>
            
            <xsl:if test="not($context-node/oe:occurrences/oe:lower='1' and $context-node/oe:occurrences/oe:upper='1')">
                <!-- CM: 16/03/2009 minOccurs must be zero when the lower !=1 and when not $context-node -->
               <!-- <xsl:attribute name="minOccurs"><xsl:value-of select="$context-node/oe:occurrences/oe:lower"/></xsl:attribute> -->
                <xsl:attribute name="minOccurs">0</xsl:attribute>
               <xsl:attribute name="maxOccurs">1</xsl:attribute> <!-- controlled by RM directly -->
            </xsl:if>
            
            <xsl:variable name="other-context" select="$context-node/oe:attributes[oe:rm_attribute_name='other_context']/oe:children"/>
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">start_time</xsl:attribute>
                        <xsl:attribute name="type">oe:DV_DATE_TIME</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">end_time</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">1</xsl:attribute>
                        <xsl:attribute name="type">oe:DV_DATE_TIME</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">location</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">1</xsl:attribute>
                        <xsl:attribute name="type">xs:string</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">setting</xsl:attribute>
                        <xsl:attribute name="type">oe:DV_CODED_TEXT</xsl:attribute>
                    </xsl:element>

                    <!-- apply templates for EVENT_CONTEXT.other_context -->
                    <xsl:for-each select="$other-context/oe:attributes[oe:rm_attribute_name='items' or oe:rm_attribute_name='item' or oe:rm_attribute_name='rows']/oe:children">
                        <xsl:choose>
                            <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                <xsl:apply-templates select=".">
                                    <xsl:with-param name="archetypeRoot" select="."/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select=".">
                                    <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">health_care_facility</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">1</xsl:attribute>
                        <xsl:attribute name="type">oe:PARTY_IDENTIFIED</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">participations</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                        <xsl:attribute name="type">oe:PARTICIPATION</xsl:attribute>
                    </xsl:element>      
                </xsl:element>
                <xsl:if test="$other-context">
                    <xsl:element name="xs:attribute">
                        <xsl:attribute name="name">other_context_node_id</xsl:attribute>
                        <xsl:attribute name="fixed"><xsl:value-of select="$other-context/oe:node_id"/></xsl:attribute>
                        <xsl:call-template name="is-fixed-attribute-required"/>
                        <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="xs:attribute">
                        <xsl:attribute name="name">other_context_type</xsl:attribute>
                        <xsl:attribute name="fixed"><xsl:value-of select="$other-context/oe:rm_type_name"/></xsl:attribute>
                        <xsl:call-template name="is-fixed-attribute-required"/>
                        <xsl:attribute name="type">xs:string</xsl:attribute>
                    </xsl:element>
                </xsl:if>
                
            </xsl:element>
        </xsl:element>
        
    </xsl:template>
    <!-- end EVENT_CONTEXT Complex object-->

    <!-- ACTION match -->
    <xsl:template match="*[(oe:rm_type_name='ACTION') and (@xsi:type='C_COMPLEX_OBJECT' or @xsi:type='C_ARCHETYPE_ROOT')]">
        <xsl:param name="archetypeRoot"/>
        
        <xsl:element name="xs:element">
            
            <xsl:call-template name="objectElementAttributes">
                <xsl:with-param name="archetypeRoot" select="."/>
                <xsl:with-param name="c_object" select="."/>
            </xsl:call-template>
            
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    
                    <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                    <xsl:call-template name="constructElementName">
                        <xsl:with-param name="archetypeRoot" select="."/>
                        <xsl:with-param name="element-name-context" select="."/>
                    </xsl:call-template>
                    
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">uid</xsl:attribute>
                        <xsl:attribute name="type">oe:UID_BASED_ID</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">1</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">links</xsl:attribute>
                        <xsl:attribute name="type">oe:LINK</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">feeder_audit</xsl:attribute>
                        <xsl:attribute name="type">oe:FEEDER_AUDIT</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:call-template name="entryAttributes">
                        <xsl:with-param name="archetypeRoot" select="."/>
                    </xsl:call-template>
                    <xsl:call-template name="careEntryAttributes">
                        <xsl:with-param name="archetypeRoot" select="."/>
                    </xsl:call-template>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">time</xsl:attribute>
                        <xsl:attribute name="type">oe:DV_DATE_TIME</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">description</xsl:attribute>
                        <xsl:element name="xs:complexType">
                            <xsl:element name="xs:sequence">
                                
                                <xsl:choose>
                                    <!-- contains 'attributes' xml elements -->
                                    <xsl:when test="count(oe:attributes)>0">
                                
                                        <!-- now process only child nodes -->
                                        <!-- apply templates for description -->
                                        <xsl:for-each select="oe:attributes[oe:rm_attribute_name='description']/oe:children">
                                            <xsl:choose>
                                                <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                                    <xsl:apply-templates select=".">
                                                        <xsl:with-param name="archetypeRoot" select="."/>
                                                    </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:apply-templates select=".">
                                                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                                    </xsl:apply-templates>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                        
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="generate-archetype-slot">
                                            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                            <xsl:with-param name="currNode" select="."/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                
                                </xsl:choose>
                                
                            </xsl:element>
                            <xsl:call-template name="archetypeNodeIdAttribute">
                                <xsl:with-param name="pathableNode" select="oe:attributes[oe:rm_attribute_name='description']/oe:children"/>
                            </xsl:call-template>
                            
                            <xsl:element name="xs:attribute">
                                <xsl:attribute name="fixed"><xsl:value-of select="oe:attributes[oe:rm_attribute_name='description']/oe:children/oe:rm_type_name"/></xsl:attribute>
                                <xsl:attribute name="name">type</xsl:attribute>
                                <xsl:call-template name="is-fixed-attribute-required"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">instruction_details</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">1</xsl:attribute>
                        <xsl:element name="xs:complexType">
                            <xsl:element name="xs:sequence">
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">instruction_id</xsl:attribute>
                                    <xsl:attribute name="type">oe:LOCATABLE_REF</xsl:attribute>
                                </xsl:element>
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">activity_id</xsl:attribute>
                                    <xsl:attribute name="type">xs:string</xsl:attribute>
                                </xsl:element>
                                <!--COMMENTED OUT FOR NEHTA <xsl:element name="xs:element">
                                    <xsl:attribute name="name">wf_details</xsl:attribute>
                                    <xsl:attribute name="type">oe:ITEM_STRUCTURE</xsl:attribute>
                                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                                    <xsl:attribute name="maxOccurs">1</xsl:attribute>
                                    </xsl:element>-->
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">ism_transition</xsl:attribute>
                        <xsl:element name="xs:complexType">
                            <xsl:element name="xs:sequence">
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">current_state</xsl:attribute>
                                    <xsl:attribute name="type">oe:DV_CODED_TEXT</xsl:attribute>
                                </xsl:element>
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">transition</xsl:attribute>
                                    <xsl:attribute name="type">oe:DV_CODED_TEXT</xsl:attribute>
                                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                                    <xsl:attribute name="maxOccurs">1</xsl:attribute>
                                </xsl:element>
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">careflow_step</xsl:attribute>
                                    <xsl:attribute name="type">oe:DV_CODED_TEXT</xsl:attribute>
                                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                                    <xsl:attribute name="maxOccurs">1</xsl:attribute>
                                    </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>

                <xsl:call-template name="archetypeNodeIdAttribute">
                    <xsl:with-param name="pathableNode" select="."/>
                </xsl:call-template>
                
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">ACTION</xsl:attribute>
                    <xsl:attribute name="name">type</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- end ACTION match -->

    <!-- ADMIN_ENTRY match -->
    <xsl:template match="*[(oe:rm_type_name='ADMIN_ENTRY') and (@xsi:type='C_COMPLEX_OBJECT' or @xsi:type='C_ARCHETYPE_ROOT')]">
        <xsl:param name="archetypeRoot"/>
        
        <xsl:element name="xs:element">
            
            <xsl:call-template name="objectElementAttributes">
                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                <xsl:with-param name="c_object" select="."/>
            </xsl:call-template>
            
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    
                    <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                    <xsl:call-template name="constructElementName">
                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                        <xsl:with-param name="element-name-context" select="."/>
                    </xsl:call-template>
                    
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">uid</xsl:attribute>
                        <xsl:attribute name="type">oe:UID_BASED_ID</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">1</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">links</xsl:attribute>
                        <xsl:attribute name="type">oe:LINK</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">feeder_audit</xsl:attribute>
                        <xsl:attribute name="type">oe:FEEDER_AUDIT</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:call-template name="entryAttributes">
                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                    </xsl:call-template>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">data</xsl:attribute>
                        <xsl:element name="xs:complexType">
                            <xsl:element name="xs:sequence">
                                
                                <xsl:choose>
                                    <!-- contains 'attributes' xml elements -->
                                    <xsl:when test="count(oe:attributes)>0">
                                        <!-- now process only child nodes -->
                                        <!-- apply templates to ADMIN_ENTRY.data -->
                                        <xsl:for-each select="oe:attributes[oe:rm_attribute_name='data']/oe:children">
                                            <xsl:choose>
                                                <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                                    <xsl:apply-templates select=".">
                                                        <xsl:with-param name="archetypeRoot" select="."/>
                                                    </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:apply-templates select=".">
                                                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                                    </xsl:apply-templates>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
                                    <xsl:otherwise>
                                        <xsl:call-template name="generate-archetype-slot">
                                            <xsl:with-param name="currNode" select="."/>
                                            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                                                               
                            </xsl:element>
                            <xsl:element name="xs:attribute">
                                <xsl:attribute name="fixed">
                                    <xsl:value-of select="oe:attributes[oe:rm_attribute_name='data']/oe:children/oe:node_id"/>
                                </xsl:attribute>
                                <xsl:attribute name="name">archetype_node_id</xsl:attribute>
                                <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                                <xsl:call-template name="is-fixed-attribute-required"/>
                            </xsl:element>
                            <xsl:element name="xs:attribute">
                                <xsl:attribute name="fixed"><xsl:value-of select="oe:attributes[oe:rm_attribute_name='data']/oe:children/oe:rm_type_name"/></xsl:attribute>
                                <xsl:attribute name="name">type</xsl:attribute>
                                <xsl:call-template name="is-fixed-attribute-required"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                
                <xsl:call-template name="archetypeNodeIdAttribute">
                    <xsl:with-param name="pathableNode" select="."/>
                </xsl:call-template>
                
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">ADMIN_ENTRY</xsl:attribute>
                    <xsl:attribute name="name">type</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- end ADMIN_ENTRY match -->

    <!-- EVALUATION match-->
    <xsl:template match="*[(oe:rm_type_name='EVALUATION') and (@xsi:type='C_COMPLEX_OBJECT' or @xsi:type='C_ARCHETYPE_ROOT')]">
    <xsl:param name="archetypeRoot"/>
        
        <xsl:element name="xs:element">

            <xsl:call-template name="objectElementAttributes">
                <xsl:with-param name="archetypeRoot" select="."/>
                <xsl:with-param name="c_object" select="."/>
            </xsl:call-template>

            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">

                    <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                    <xsl:call-template name="constructElementName">
                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                        <xsl:with-param name="element-name-context" select="."/>
                    </xsl:call-template>

                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">uid</xsl:attribute>
                        <xsl:attribute name="type">oe:UID_BASED_ID</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">1</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">links</xsl:attribute>
                        <xsl:attribute name="type">oe:LINK</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">feeder_audit</xsl:attribute>
                        <xsl:attribute name="type">oe:FEEDER_AUDIT</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:call-template name="entryAttributes">
                        <xsl:with-param name="archetypeRoot" select="."/>
                    </xsl:call-template>
                    <xsl:call-template name="careEntryAttributes">
                        <xsl:with-param name="archetypeRoot" select="."/>
                    </xsl:call-template>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">data</xsl:attribute>
                        <xsl:element name="xs:complexType">
                            <xsl:element name="xs:sequence">

                                <xsl:choose>
                                    <!-- contains 'attributes' xml elements -->
                                    <xsl:when test="count(oe:attributes)>0">
                                        <!-- now process only child nodes -->
                                        <!-- apply templates to EVALUATION.data -->
                                        <xsl:for-each select="oe:attributes[oe:rm_attribute_name='data']/oe:children">
                                            <xsl:choose>
                                                <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                                    <xsl:apply-templates select=".">
                                                        <xsl:with-param name="archetypeRoot" select="."/>
                                                    </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:apply-templates select=".">
                                                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                                    </xsl:apply-templates>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
                                    <xsl:otherwise>
                                        <xsl:call-template name="generate-archetype-slot">
                                            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                            <xsl:with-param name="currNode" select="."/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>

                            </xsl:element>
                            
                            <xsl:call-template name="archetypeNodeIdAttribute">
                                <xsl:with-param name="pathableNode" select="oe:attributes[oe:rm_attribute_name='data']/oe:children"/>
                            </xsl:call-template>
     
                            <xsl:element name="xs:attribute">
                                <xsl:attribute name="fixed"><xsl:value-of select="oe:attributes[oe:rm_attribute_name='data']/oe:children/oe:rm_type_name"/></xsl:attribute>
                                <xsl:attribute name="name">type</xsl:attribute>
                                <xsl:call-template name="is-fixed-attribute-required"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>

                <xsl:call-template name="archetypeNodeIdAttribute">
                    <xsl:with-param name="pathableNode" select="."/>
                </xsl:call-template>
                
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">EVALUATION</xsl:attribute>
                    <xsl:attribute name="name">type</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- end EVALUATION match -->

    <!-- OBSERVATION match -->
    <xsl:template match="*[(oe:rm_type_name='OBSERVATION') and (@xsi:type='C_COMPLEX_OBJECT' or @xsi:type='C_ARCHETYPE_ROOT')]">
        <xsl:param name="archetypeRoot"/>
        
        <xsl:element name="xs:element">
            
            <xsl:call-template name="objectElementAttributes">
                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                <xsl:with-param name="c_object" select="."/>
            </xsl:call-template>
            
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    
                    <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                    <xsl:call-template name="constructElementName">
                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                        <xsl:with-param name="element-name-context" select="."/>
                    </xsl:call-template>
                    
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">uid</xsl:attribute>
                        <xsl:attribute name="type">oe:UID_BASED_ID</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">1</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">links</xsl:attribute>
                        <xsl:attribute name="type">oe:LINK</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">feeder_audit</xsl:attribute>
                        <xsl:attribute name="type">oe:FEEDER_AUDIT</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:call-template name="entryAttributes">
                        <xsl:with-param name="archetypeRoot" select="."/>
                    </xsl:call-template>
                    <xsl:call-template name="careEntryAttributes">
                        <xsl:with-param name="archetypeRoot" select="."/>
                    </xsl:call-template>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">data</xsl:attribute>
                        <xsl:element name="xs:complexType">
                            <xsl:element name="xs:sequence">
                                
                                <xsl:choose>
                                    <!-- contains 'attributes' xml elements -->
                                    <xsl:when test="count(oe:attributes[oe:rm_attribute_name='data'])>0">
                                        <!-- now process only child nodes -->
                                        <!-- apply templates to OBSERVATION.data -->
                                        <xsl:for-each select="oe:attributes[oe:rm_attribute_name='data']/oe:children">
                                            <xsl:choose>
                                                <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                                    <xsl:apply-templates select=".">
                                                        <xsl:with-param name="archetypeRoot" select="."/>
                                                    </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:apply-templates select=".">
                                                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                                    </xsl:apply-templates>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
                                    <xsl:otherwise>
                                        <xsl:call-template name="generate-archetype-slot">
                                            <xsl:with-param name="currNode" select="."/>
                                            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                                
                            </xsl:element>
                            <xsl:element name="xs:attribute">
                                <xsl:attribute name="fixed">
                                    <xsl:value-of select="oe:attributes[oe:rm_attribute_name='data']/oe:children/oe:node_id"/>
                                </xsl:attribute>
                                <xsl:attribute name="name">archetype_node_id</xsl:attribute>
                                <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                                <xsl:call-template name="is-fixed-attribute-required"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    
                    <!-- assumes that the lack of a constraint on state means state is EXCLUDED from the schema (like protocol) -->
                    <xsl:if test="oe:attributes[oe:rm_attribute_name='state']">
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">state</xsl:attribute>
                            <xsl:attribute name="minOccurs">0</xsl:attribute><!--<xsl:value-of select="$archetypeRoot/oe:attributes[oe:rm_attribute_name='state']/oe:existence/oe:lower" />-->
                            <xsl:attribute name="maxOccurs">
                                <xsl:value-of select="oe:attributes[oe:rm_attribute_name='state']/oe:existence/oe:upper"/>
                            </xsl:attribute>
                            <xsl:element name="xs:complexType">
                                <xsl:element name="xs:sequence">
                                    
                                    <xsl:choose>
                                        <!-- contains 'attributes' xml elements -->
                                        <xsl:when test="count(oe:attributes[oe:rm_attribute_name='state'])>0">
                                            <!-- now process only child nodes -->
                                            <!-- apply templates to OBSERVATION.state -->
                                            <xsl:for-each select="oe:attributes[oe:rm_attribute_name='state']/oe:children">
                                                <xsl:choose>
                                                    <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                                        <xsl:apply-templates select=".">
                                                            <xsl:with-param name="archetypeRoot" select="."/>
                                                        </xsl:apply-templates>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:apply-templates select=".">
                                                            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                                        </xsl:apply-templates>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
                                        <xsl:otherwise>
                                            <xsl:call-template name="generate-archetype-slot">
                                                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                                <xsl:with-param name="currNode" select="."/>
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    
                                </xsl:element>

                                <xsl:element name="xs:attribute">
                                    <xsl:attribute name="fixed">
                                        <xsl:value-of select="oe:attributes[oe:rm_attribute_name='state']/oe:children/oe:node_id"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="name">archetype_node_id</xsl:attribute>
                                    <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                                    <xsl:call-template name="is-fixed-attribute-required"/>
                                </xsl:element>
                                <xsl:element name="xs:attribute">
                                    <xsl:attribute name="fixed">
                                        <xsl:value-of select="oe:attributes[oe:rm_attribute_name='state']/oe:children/oe:rm_type_name"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="name">type</xsl:attribute>
                                    <xsl:call-template name="is-fixed-attribute-required"/>
                                </xsl:element>
                            </xsl:element>

                               <!-- <xsl:call-template name="archetypeNodeIdAttribute">
                                    <xsl:with-param name="pathableNode" select="oe:attributes[oe:rm_attribute_name='state']/oe:children"/>
                                </xsl:call-template>
                                
                                <xsl:element name="xs:attribute">
                                    <xsl:attribute name="fixed">--><!--<xsl:value-of select="../oe:attributes[oe:rm_attribute_name='state']/oe:children/oe:rm_type_name"/></xsl:attribute>-->
                                    <!--<xsl:attribute name="name">type</xsl:attribute>
                                        <xsl:call-template name="is-fixed-attribute-required"/>
                                </xsl:element>
                                </xsl:element>-->
                        </xsl:element>
                    </xsl:if>
                </xsl:element>

                <xsl:call-template name="archetypeNodeIdAttribute">
                    <xsl:with-param name="pathableNode" select="."/>
                </xsl:call-template>
                
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">OBSERVATION</xsl:attribute>
                    <xsl:attribute name="name">type</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- end OBSERVATION match -->

    <!-- ACTIVITY match-->
    <!-- ACTIVITY match-->
    <xsl:template match="*[(oe:rm_type_name='ACTIVITY') and (@xsi:type='C_COMPLEX_OBJECT' or @xsi:type='C_ARCHETYPE_ROOT')]">
        <xsl:param name="archetypeRoot"/>
        
        <xsl:element name="xs:element">
            
            <xsl:call-template name="objectElementAttributes">
                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                <xsl:with-param name="c_object" select="."/>
            </xsl:call-template>
            
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    
                    <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                    <xsl:call-template name="constructElementName">
                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                        <xsl:with-param name="element-name-context" select="."/>
                    </xsl:call-template>
                    
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">uid</xsl:attribute>
                        <xsl:attribute name="type">oe:UID_BASED_ID</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">1</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">links</xsl:attribute>
                        <xsl:attribute name="type">oe:LINK</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">timing</xsl:attribute>
                        <xsl:attribute name="type">oe:DV_PARSABLE</xsl:attribute>
                    </xsl:element>
                    
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">description</xsl:attribute>
                        <xsl:element name="xs:complexType">
                            <xsl:element name="xs:sequence">
                                
                                <xsl:choose>
                                    <!-- contains 'attributes' xml elements -->
                                    <xsl:when test="count(oe:attributes)>0">
                                        <!--If description has multiple children, provide a choice element wrapping around description children--> 
                                        <xsl:if test="count(oe:attributes[oe:rm_attribute_name='description']/oe:children)>1">
                                            &lt;xsl:element name="xs:choice"&gt;
                                        </xsl:if>
                                        
                                        <!-- now process only child nodes -->
                                        <!-- apply templates for activity.description -->
                                        <xsl:for-each select="oe:attributes[oe:rm_attribute_name='description']/oe:children">
                                            
                                            <xsl:choose>
                                                <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                                    <xsl:apply-templates select=".">
                                                        <xsl:with-param name="archetypeRoot" select="."/>
                                                    </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:apply-templates select=".">
                                                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                                    </xsl:apply-templates>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            
                                        </xsl:for-each>
                                        
                                        <!-- end choice tag if multiple -->
                                        <xsl:if test="count(oe:attributes[oe:rm_attribute_name='description']/oe:children)>1">
                                            &lt;/xsl:element&gt;
                                        </xsl:if>
                                    </xsl:when>
                                    <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
                                    <xsl:otherwise>
                                        <xsl:call-template name="generate-archetype-slot">
                                            <xsl:with-param name="currNode" select="."/>
                                            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                                
                            </xsl:element>
                            <xsl:element name="xs:attribute">
                                <xsl:attribute name="fixed">
                                    <xsl:value-of select="oe:attributes[oe:rm_attribute_name='description']/oe:children/oe:node_id"/>
                                </xsl:attribute>
                                <xsl:attribute name="name">archetype_node_id</xsl:attribute>
                                <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                                <xsl:call-template name="is-fixed-attribute-required"/>
                            </xsl:element>
                            <xsl:element name="xs:attribute">
                                <xsl:attribute name="fixed"><xsl:value-of select="oe:attributes[oe:rm_attribute_name='description']/oe:children/oe:rm_type_name"/></xsl:attribute>
                                <xsl:attribute name="name">type</xsl:attribute>
                                <xsl:call-template name="is-fixed-attribute-required"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    
                    <!-- sb: added 06/03/08 [TMP-463] -->
                    <xsl:element name="xs:element">
                        
                        <xsl:attribute name="name">action_archetype_id</xsl:attribute>
                        
                        <xsl:choose>
                            <!-- C_STRING PATTERN constraint -->
                            <xsl:when test="oe:attributes[oe:rm_attribute_name='action_archetype_id']/oe:children/oe:item[@xsi:type='C_STRING']/oe:pattern">
                                <xsl:element name="xs:simpleType">
                                    <xsl:element name="xs:restriction">
                                        <xsl:attribute name="base">xs:string</xsl:attribute>
                                        <xsl:element name="xs:pattern">
                                            <!--value="([a-zA-Z][\w_]*-[\w][\w_]*-[\w][\w_]*\.[\w][\w_]*(-[\w][\w_]*)*\.v\d+(\.\d)*)|(at(0\.[0-9]{1,4}|[0-9]{4})(\.[0-9]{1,3})*)"-->
                                            <xsl:attribute name="value">
                                                <xsl:variable name="pattern">
                                                    <!-- sb: 12/03/08 need to remove this call-template once TLS-16 and TMP-470 have been resolved. -->
                                                    <xsl:call-template name="replaceActionArchetypeIdSpecialChars">
                                                        <xsl:with-param name="element-name" select="oe:attributes[oe:rm_attribute_name='action_archetype_id']/oe:children/oe:item[@xsi:type='C_STRING']/oe:pattern"/>
                                                    </xsl:call-template>
                                                </xsl:variable>
                                                <xsl:choose>
                                                    <xsl:when test="not(contains($pattern, '-'))"><xsl:text xml:space="default">[a-zA-Z][\w_]*-[\w][\w_]*-[\w][\w_]*\.</xsl:text>
                                                        <xsl:choose>
                                                            <xsl:when test="contains($pattern, '.')">
                                                                <xsl:if test="contains(substring-after($pattern, '.'), 'v')">
                                                                    <xsl:if test="number(substring-after($pattern, 'v'))">
                                                                        <xsl:value-of select="$pattern"/>
                                                                    </xsl:if>
                                                                </xsl:if>
                                                            </xsl:when>
                                                            <xsl:otherwise><xsl:value-of select="$pattern"/></xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="$pattern"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <!-- C_STRING LIST constraint -->
                            <xsl:when test="oe:attributes[oe:rm_attribute_name='action_archetype_id']/oe:children/oe:item[@xsi:type='C_STRING']/oe:list">
                                <xsl:text disable-output-escaping="yes">&lt;!-- NOT IMPLEMENTED --&gt;</xsl:text>
                            </xsl:when>
                            <!-- NOT YET IMPLEMENTED (just prints the text as is). 
                                n.b. other C_STRING constraints are list_open and assumed_value which are not yet implemented in the OPT .-->
                            <xsl:otherwise>
                                <xsl:text disable-output-escaping="yes">&lt;!-- NOT IMPLEMENTED --&gt;</xsl:text>
                                <xsl:value-of select="oe:attributes[oe:rm_attribute_name='action_archetype_id']/oe:children/oe:item[@xsi:type='C_STRING']/text()"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:element>
                    <!-- end added. -->
                    
                </xsl:element>
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">
                        <xsl:value-of select="oe:node_id"/>
                    </xsl:attribute>
                    <xsl:attribute name="name">archetype_node_id</xsl:attribute>
                    <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">ACTIVITY</xsl:attribute>
                    <xsl:attribute name="name">type</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- end ACTIVITY match-->
    
    <!-- end ACTIVITY match-->
    
    <!-- HISTORY match -->
    <xsl:template match="*[oe:rm_type_name='HISTORY']">
        <xsl:param name="archetypeRoot"/><!-- observation node -->
                          
        <xsl:element name="xs:element">
            <xsl:attribute name="name">origin</xsl:attribute>
            <xsl:attribute name="type">oe:DV_DATE_TIME</xsl:attribute>
            <xsl:attribute name="minOccurs">0</xsl:attribute><!-- this is derivable from the event.time (and width) values - therefore, automatically populated when committed. -->
        </xsl:element>
                           
        <!-- apply templates to HISTORY.events -->
        <xsl:for-each select="oe:attributes[oe:rm_attribute_name='events']/oe:children">
            <xsl:choose>
                <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                    <xsl:apply-templates select=".">
                        <xsl:with-param name="archetypeRoot" select="."/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select=".">
                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>  
        
    </xsl:template>
    <!-- end HISTORY match -->
    
    <!-- EVENT match [TMP-964] -->
    <xsl:template match="oe:children[oe:rm_type_name='EVENT']">
        <xsl:param name="archetypeRoot"/><!-- observation node -->
           

        <xsl:element name="xs:choice">
        	<xsl:if test="not(oe:occurrences/oe:lower='1' and oe:occurrences/oe:upper='1')">
        		<xsl:attribute name="minOccurs"><xsl:value-of select="oe:occurrences/oe:lower"/></xsl:attribute>
        		<xsl:choose>
        			<xsl:when test="oe:occurrences/oe:upper_unbounded='true'"><xsl:attribute name="maxOccurs">unbounded</xsl:attribute></xsl:when>
        			<xsl:when test="not(oe:occurrences/oe:upper='1')"><xsl:attribute name="maxOccurs"><xsl:value-of select="oe:occurrences/oe:upper"/></xsl:attribute></xsl:when>
        		</xsl:choose>
        	</xsl:if>
            <xsl:call-template name="construct-event-structure">
                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                <xsl:with-param name="current-node" select="."/>
                <xsl:with-param name="is-events-type-constrained">false</xsl:with-param>
                <xsl:with-param name="events-type">POINT_EVENT</xsl:with-param>
            	  <xsl:with-param name="ouput-xml-occurrences">no</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="construct-event-structure">
                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                <xsl:with-param name="current-node" select="."/>
                <xsl:with-param name="is-events-type-constrained">false</xsl:with-param>
                <xsl:with-param name="events-type">INTERVAL_EVENT</xsl:with-param>
            	  <xsl:with-param name="ouput-xml-occurrences">no</xsl:with-param>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <!-- end EVENT match -->
    
    <!-- POINT_EVENT or INTERVAL_EVENT match -->
    <xsl:template match="oe:children[oe:rm_type_name='POINT_EVENT' or oe:rm_type_name='INTERVAL_EVENT']">
        <xsl:param name="archetypeRoot"/><!-- observation node -->
        
        <xsl:call-template name="construct-event-structure">
            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
            <xsl:with-param name="current-node" select="."/>
            <xsl:with-param name="is-events-type-constrained">true</xsl:with-param>
        	 <xsl:with-param name="ouput-xml-occurrences">yes</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <!-- end POINT_EVENT or INTERVAL_EVENT match -->
    
    <!-- Construct POINT_EVENT or INTERVAL_EVENT structure -->
    <xsl:template name="construct-event-structure">
        <xsl:param name="archetypeRoot"/><!-- observation node -->
        <xsl:param name="current-node"/>
        <xsl:param name="is-events-type-constrained"/><!-- boolean to indicate if the events type has been constrained to POINT_EVENT or INTERVAL_EVENT or not -->
        <xsl:param name="events-type"/>
    	 <xsl:param name="ouput-xml-occurrences">yes</xsl:param>
        
        <xsl:element name="xs:element">    
            
            <xsl:choose>
                <xsl:when test="$is-events-type-constrained='false'"><!-- is EVENTS type (i.e. type of event has not been constrained) -->
                    <xsl:choose>
                        <xsl:when test="$events-type='POINT_EVENT'">
                            <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                            <xsl:call-template name="objectElementAttributes">
                                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                <xsl:with-param name="c_object" select="$current-node"/>
                            		<xsl:with-param name="ouput-xml-occurrences" select="$ouput-xml-occurrences"/>
                                <xsl:with-param name="event-name-to-concatenate">_as_Point_Event</xsl:with-param><!-- events-type to concatenate as part of the XML element name (to satisfy XSD unique particle attribution rule)  -->
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$events-type='INTERVAL_EVENT'">
                            <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                            <xsl:call-template name="objectElementAttributes">
                                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                <xsl:with-param name="c_object" select="$current-node"/>
                            	<xsl:with-param name="ouput-xml-occurrences" select="$ouput-xml-occurrences"/>
                                <xsl:with-param name="event-name-to-concatenate">_as_Interval_Event</xsl:with-param><!-- events-type to concatenate as part of the XML element name (to satisfy XSD unique particle attribution rule)  -->
                            </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise><!-- EVENTS type has been constrained to either POINT_EVENT or INTERVAL_EVENT -->
                    <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                    <xsl:call-template name="objectElementAttributes">
                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                        <xsl:with-param name="c_object" select="$current-node"/>
                    	<xsl:with-param name="ouput-xml-occurrences" select="$ouput-xml-occurrences"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    
                    <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                    <xsl:call-template name="constructElementName">
                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                        <xsl:with-param name="element-name-context" select="$current-node"/>
                    </xsl:call-template>

                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">time</xsl:attribute>
                        <xsl:attribute name="type">oe:DV_DATE_TIME</xsl:attribute>
                    </xsl:element>
                                       
                    <xsl:if test="$current-node/oe:rm_type_name='INTERVAL_EVENT' or $events-type='INTERVAL_EVENT'">
                        
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">width</xsl:attribute>
                            
                            <xsl:choose>
                                <!-- apply width/offset constraint -->
                                <xsl:when test="$current-node/oe:attributes[oe:rm_attribute_name='width' or oe:rm_attribute_name='offset']/oe:children/oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:item/oe:range">
                                    <xsl:choose>
                                        <!-- assumes that the 'lower' and 'upper' range values are equal because width/offset value is actually a single fixed value 
                                            and that we assume that the duration will be in ISO duration format. -->
                                        <xsl:when test="($current-node/oe:attributes[oe:rm_attribute_name='width' or oe:rm_attribute_name='offset']/oe:children/oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:item/oe:range/oe:lower)
                                            and ($current-node/oe:attributes[oe:rm_attribute_name='width' or oe:rm_attribute_name='offset']/oe:children/oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:item/oe:range/oe:upper)">
                                            
                                            <!-- Width is DV_DURATION so has 'value' element -->
                                            <xsl:element name="xs:complexType">
                                                <xsl:element name="xs:sequence">
                                                    <xsl:element name="xs:element">
                                                        <xsl:attribute name="name">value</xsl:attribute>
                                                        <xsl:attribute name="type">xs:string</xsl:attribute>
                                                        <xsl:attribute name="fixed">
                                                            <xsl:value-of select="$current-node/oe:attributes[oe:rm_attribute_name='width' or oe:rm_attribute_name='offset']/oe:children/oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:item/oe:range/oe:lower"/>
                                                        </xsl:attribute>
                                                    </xsl:element>
                                                </xsl:element>
                                            </xsl:element>
                                            
                                        </xsl:when>
                                    </xsl:choose>
                                    
                                </xsl:when>
                                <!-- no width/offset constraint -->
                                <xsl:otherwise>
                                    <xsl:attribute name="type">oe:DV_DURATION</xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                        </xsl:element>
                        
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">math_function</xsl:attribute>
                            
                            <xsl:choose>
                                
                                <xsl:when test="$current-node/oe:attributes[oe:rm_attribute_name='math_function']/oe:children/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list">
                                    
                                    <!-- math_function is a DV_CODED_TEXT so has value and 'defining_code' (CODE_PHRASE) -->
                                    <xsl:element name="xs:complexType">
                                        <xsl:element name="xs:sequence">
                                            
                                            <xsl:element name="xs:element">
                                                <xsl:attribute name="name">value</xsl:attribute>
                                                <xsl:attribute name="type">xs:string</xsl:attribute>
                                            </xsl:element>
                                            
                                            <xsl:element name="xs:element">
                                                <xsl:attribute name="name">defining_code</xsl:attribute>
                                                <xsl:element name="xs:complexType">
                                                    <xsl:element name="xs:sequence">
                                                        <xsl:element name="xs:element">
                                                            <xsl:attribute name="name">terminology_id</xsl:attribute>
                                                            <xsl:element name="xs:complexType">
                                                                <xsl:element name="xs:sequence">
                                                                    <xsl:element name="xs:element">
                                                                        <xsl:attribute name="name">value</xsl:attribute>
                                                                        <xsl:attribute name="fixed"><xsl:value-of select="$current-node/oe:attributes[oe:rm_attribute_name='math_function']/oe:children/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:terminology_id/oe:value"/></xsl:attribute>
                                                                        <xsl:attribute name="type">xs:token</xsl:attribute>
                                                                    </xsl:element>
                                                                </xsl:element>
                                                            </xsl:element>
                                                        </xsl:element>
                                                        <xsl:element name="xs:element">
                                                            <xsl:attribute name="name">code_string</xsl:attribute>
                                                            <xsl:choose>
                                                                <xsl:when test="count($current-node/oe:attributes[oe:rm_attribute_name='math_function']/oe:children/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list)>1">
                                                                    <xsl:element name="xs:simpleType">
                                                                        <xsl:element name="xs:restriction">
                                                                            <xsl:attribute name="base">xs:string</xsl:attribute>
                                                                            
                                                                            <xsl:for-each select="$current-node/oe:attributes[oe:rm_attribute_name='math_function']/oe:children/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list">
                                                                                <xsl:element name="xs:enumeration">
                                                                                    <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                                                                </xsl:element>
                                                                            </xsl:for-each>
                                                                            
                                                                        </xsl:element>
                                                                    </xsl:element>
                                                                </xsl:when>
                                                                <xsl:when test="count($current-node/oe:attributes[oe:rm_attribute_name='math_function']/oe:children/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list)=1">
                                                                    <xsl:attribute name="fixed"><xsl:value-of select="$current-node/oe:attributes[oe:rm_attribute_name='math_function']/oe:children/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list"/></xsl:attribute>
                                                                    <xsl:attribute name="type">xs:string</xsl:attribute>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                        </xsl:element>
                                                    </xsl:element>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:element>
                                    
                                </xsl:when>
                                
                                <xsl:otherwise>
                                    <xsl:attribute name="type">oe:DV_CODED_TEXT</xsl:attribute>
                                </xsl:otherwise>
                                
                            </xsl:choose>
                            
                        </xsl:element>
                        
                    </xsl:if>
                    
                    <!--not yet implemented by the AE and Template designer tools so commented out for now...<xsl:element name="xs:element">
                        <xsl:attribute name="name">sample_count</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:attribute name="maxOccurs">1</xsl:attribute>
                        <xsl:attribute name="type">xs:integer</xsl:attribute>
                    </xsl:element>-->
                                        
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">data</xsl:attribute>
                        <xsl:element name="xs:complexType">
                            <xsl:element name="xs:sequence">
                                
                                <xsl:choose>
                                    <!-- contains 'attributes' xml elements -->
                                    <xsl:when test="count($current-node/oe:attributes[oe:rm_attribute_name='data'])>0">
                                        
                                        <!-- now process only child nodes -->
                                        <!-- apply templates for (OBSERVATION).EVENT.data -->
                                        <xsl:for-each select="$current-node/oe:attributes[oe:rm_attribute_name='data']/oe:children">
                                            <xsl:choose>
                                                <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                                    <xsl:apply-templates select=".">
                                                        <xsl:with-param name="archetypeRoot" select="."/>
                                                    </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:apply-templates select=".">
                                                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                                    </xsl:apply-templates>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                        
                                    </xsl:when>
                                    <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
                                    <xsl:otherwise>
                                        <xsl:call-template name="generate-archetype-slot">
                                            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                            <xsl:with-param name="currNode" select="."/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                                
                            </xsl:element>
                            <xsl:element name="xs:attribute">
                                <xsl:attribute name="fixed">
                                    <!--sb: removed 24/01/08 <xsl:value-of select="oe:node_id"/>-->
                                    <!-- sb: changed incorrect xpath to (24/01/08) -->
                                    <xsl:value-of select="$current-node/oe:attributes[oe:rm_attribute_name='data']/oe:children/oe:node_id"/>
                                    <!-- end change -->
                                </xsl:attribute>
                                <xsl:attribute name="name">archetype_node_id</xsl:attribute>
                                <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                                <xsl:call-template name="is-fixed-attribute-required"/>
                            </xsl:element>
                            <!-- <xsl:attribute name="type">oe:<xsl:value-of select="oe:attributes[oe:rm_attribute_name='data']/oe:rm_type_name"/></xsl:attribute>-->
                            <!-- sb: added 24/01/08 -->
                            <xsl:element name="xs:attribute">
                                <xsl:attribute name="fixed">
                                    <xsl:value-of select="$current-node/oe:attributes[oe:rm_attribute_name='data']/oe:children/oe:rm_type_name"/>
                                </xsl:attribute>
                                <xsl:attribute name="name">type</xsl:attribute>
                                <xsl:call-template name="is-fixed-attribute-required"/>
                            </xsl:element>
                            <!-- end added -->
                        </xsl:element>
                    </xsl:element>
                    
                    <xsl:if test="$current-node/oe:attributes[oe:rm_attribute_name='state']/oe:children">
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">state</xsl:attribute>
                            <xsl:element name="xs:complexType">
                                <xsl:element name="xs:sequence">
                                    
                                    <xsl:choose>
                                        <!-- contains 'attributes' xml elements -->
                                        <xsl:when test="count($current-node/oe:attributes[oe:rm_attribute_name='state'])>0">
                                            <!-- now process only child nodes -->
                                            <!-- apply templates for (OBSERVATION).EVENT.state -->
                                            <xsl:for-each select="$current-node/oe:attributes[oe:rm_attribute_name='state']/oe:children">
                                                <xsl:choose>
                                                    <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                                        <xsl:apply-templates select=".">
                                                            <xsl:with-param name="archetypeRoot" select="."/>
                                                        </xsl:apply-templates>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:apply-templates select=".">
                                                            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                                        </xsl:apply-templates>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
                                        <xsl:otherwise>
                                            <xsl:call-template name="generate-archetype-slot">
                                                <xsl:with-param name="currNode" select="."/>
                                                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    
                                </xsl:element>
                                <xsl:element name="xs:attribute">
                                    <xsl:attribute name="fixed">
                                        <!--sb: removed 24/01/08 <xsl:value-of select="oe:node_id"/>-->
                                        <!-- sb: changed incorrect xpath to (24/01/08) -->
                                        <xsl:value-of select="$current-node/oe:attributes[oe:rm_attribute_name='state']/oe:children/oe:node_id"/>
                                        <!-- end change -->
                                    </xsl:attribute>
                                    <xsl:attribute name="name">archetype_node_id</xsl:attribute>
                                    <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                                    <xsl:call-template name="is-fixed-attribute-required"/>
                                </xsl:element>
                                <!-- <xsl:attribute name="type">oe:<xsl:value-of select="oe:attributes[oe:rm_attribute_name='state']/oe:rm_type_name"/></xsl:attribute>-->
                                <!-- sb: added 24/01/08 -->
                                <xsl:element name="xs:attribute">
                                    <xsl:attribute name="fixed">
                                        <xsl:value-of select="$current-node/oe:attributes[oe:rm_attribute_name='state']/oe:children/oe:rm_type_name"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="name">type</xsl:attribute>
                                    <xsl:call-template name="is-fixed-attribute-required"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    
                </xsl:element>
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">
                        <xsl:value-of select="$current-node/oe:node_id"/>
                    </xsl:attribute>
                    <xsl:attribute name="name">archetype_node_id</xsl:attribute>
                    <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
                <xsl:element name="xs:attribute">
                    <!-- sb: removed 23/01/08<xsl:attribute name="fixed">
                         oe: <xsl:value-of select="oe:rm_type_name"/>
                    </xsl:attribute> -->
                    <xsl:attribute name="name">type</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                    
                    <xsl:choose>
                        <xsl:when test="$current-node/oe:rm_type_name='POINT_EVENT' or $events-type='POINT_EVENT'">
                            <xsl:attribute name="fixed">POINT_EVENT</xsl:attribute>
                        </xsl:when>
                        <xsl:when test="$current-node/oe:rm_type_name='INTERVAL_EVENT' or $events-type='INTERVAL_EVENT'">
                            <xsl:attribute name="fixed">INTERVAL_EVENT</xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                    
                </xsl:element>
                
            </xsl:element>
        </xsl:element>

    </xsl:template>
    <!-- end EVENT match -->

    <!-- CLUSTER (C_COMPLEX_OBJECT or C_ARCHETYPE_ROOT) match -->
    <xsl:template match="*[(oe:rm_type_name='CLUSTER') and (@xsi:type='C_COMPLEX_OBJECT' or @xsi:type='C_ARCHETYPE_ROOT')]">
        <xsl:param name="archetypeRoot"/>
        
        <xsl:element name="xs:element">
            
            <xsl:call-template name="objectElementAttributes">
                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                <xsl:with-param name="c_object" select="."/>
            </xsl:call-template>
            
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    
                    <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                    <xsl:call-template name="constructElementName">
                        <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                        <xsl:with-param name="element-name-context" select="."/>
                    </xsl:call-template>
                    
                    <xsl:choose>
                        <!-- contains 'attributes' xml elements -->
                        <xsl:when test="count(oe:attributes)>0">

                            <!-- process child node that is a C_ARCHETYPE_ROOT or a C_COMPLEX_OBJECT -->
                            <xsl:for-each select="oe:attributes[oe:rm_attribute_name='items']/oe:children">
                                <!-- apply templates to CLUSTER.items -->
                                <xsl:choose>
                                    <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                        <xsl:apply-templates select=".">
                                            <xsl:with-param name="archetypeRoot" select="."/>
                                        </xsl:apply-templates>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select=".">
                                            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                        </xsl:apply-templates>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                            
                        </xsl:when>
                        <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
                        <xsl:otherwise>
                            <xsl:call-template name="generate-archetype-slot">
                                <xsl:with-param name="currNode" select="."/>
                                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                                       
                </xsl:element>
                
                <xsl:call-template name="archetypeNodeIdAttribute">
                    <xsl:with-param name="pathableNode" select="."/>
                </xsl:call-template>
                
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">CLUSTER</xsl:attribute>
                    <xsl:attribute name="name">type</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- end CLUSTER  Complex Object match -->
    
    <!-- ELEMENT (ARCHETYPE_ROOT) match - TOTEST :sb: 13/07/08.-->
    <xsl:template match="*[(oe:rm_type_name='ELEMENT') and (@xsi:type='C_ARCHETYPE_ROOT')]">
        <xsl:param name="archetypeRoot" select="."/>
        
        <xsl:element name="xs:element">
            
            <!-- call objectElementAttributes -->
            <xsl:call-template name="objectElementAttributes">
                <xsl:with-param name="archetypeRoot" select="."/>
                <xsl:with-param name="c_object" select="."/>
            </xsl:call-template>
            
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    
                   <!-- SAB added 04/03/2008 to replace call-template 'constructTextAttribute' -->
                   <xsl:call-template name="constructElementName">
                       <xsl:with-param name="archetypeRoot" select="."/>
                       <xsl:with-param name="element-name-context" select="."/>
                   </xsl:call-template>
                   
                	<!-- LMT added 29/04/2010 for TMP-1234 choice between ELEMENT.value or ELEMENT.null_flavour -->
                	<xsl:element name="xs:choice">
                		
                    <xsl:choose>
                        
                        <!-- handle MULTIPLE data type data values or MULTIPLE C_QUANTITY_ITEMs for a DV_QUANTITY -->
                        <xsl:when test="(count(oe:attributes[oe:rm_attribute_name='value']/oe:children)>1)
                            or (count(oe:attributes[oe:rm_attribute_name='value']/oe:children[oe:rm_type_name='DV_QUANTITY']/oe:list)>1)">
                            <xsl:element name="xs:choice">
                                <!-- multiple quantity items -->
                                <xsl:for-each select="oe:attributes[oe:rm_attribute_name='value']/oe:children[oe:rm_type_name='DV_QUANTITY']/oe:list">
                                    <xsl:element name="xs:element">
                                        
                                        <xsl:attribute name="name">
                                            
                                            <xsl:choose>
                                                <xsl:when test="count(parent::node()/oe:list)>1">
                                                    
                                                    <!-- variable to used to check if the unit starts with a number or not -->
                                                    <xsl:variable name="first-char" select="number(substring(oe:units, 1, 1))"/>
                                                    
                                                    <xsl:choose>
                                                        <xsl:when test="oe:units='7.72E+08 rad/h2'">angular_acceleration_value</xsl:when>
                                                        <!-- check if this unit starts with a number -->
                                                        <xsl:when test="$first-char = 0 or $first-char = 1 or $first-char = 2 or $first-char = 3 or $first-char = 4 or $first-char = 5 or $first-char = 6 or $first-char = 7 or $first-char = 8 or $first-char = 9">
                                                            <xsl:call-template name="formatPropertyUnitName">
                                                                <xsl:with-param name="property-unit">
                                                                    <xsl:text xml:space="preserve">_</xsl:text><xsl:value-of select="oe:units"/>_value
                                                                </xsl:with-param>
                                                            </xsl:call-template>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:call-template name="formatPropertyUnitName">
                                                                <xsl:with-param name="property-unit"><xsl:value-of select="oe:units"/>_value</xsl:with-param>
                                                            </xsl:call-template>
                                                        </xsl:otherwise>
                                                    </xsl:choose>

                                                </xsl:when>
                                                <xsl:otherwise>value</xsl:otherwise>
                                            </xsl:choose>
                                            
                                        </xsl:attribute>
                                        
                                        <xsl:attribute name="minOccurs">0</xsl:attribute><!-- optional to support null values -->
                                        
                                        <xsl:call-template name="applyQuantityItemConstraint">
                                            <xsl:with-param name="currNode" select="."/>
                                        </xsl:call-template>
                                        
                                    </xsl:element>
                                </xsl:for-each>
                                <!-- multiple INTERVAL type -->
                                <xsl:for-each select="oe:attributes[oe:rm_attribute_name='value']/oe:children[starts-with(oe:rm_type_name, 'DV_INTERVAL')]">
                                    
                                    <xsl:variable name="valueName">
                                        <xsl:variable name="temp-interval-type">
                                            <xsl:value-of select="substring-after(oe:rm_type_name, 'DV_INTERVAL&lt;DV_')"/>
                                        </xsl:variable>
                                        <xsl:variable name="interval-type">
                                            <xsl:value-of select="substring-before($temp-interval-type, '&gt;')"/>
                                        </xsl:variable>
                                        <!-- check if there are multiple C_QUANTITY_ITEMs for a DV_QUANTITY INTERVAL -->
                                        <xsl:choose>
                                            <!-- applies to quantity-type intervals only -->
                                            <xsl:when test="(contains(oe:rm_type_name, 'DV_QUANTITY')) and
                                                (count(current()[oe:rm_type_name='DV_QUANTITY']/oe:list)>1)">
                                                <!-- multiple quantity items -->
                                                <xsl:for-each select="oe:attributes[oe:rm_attribute_name='value']/oe:children[oe:rm_type_name='DV_QUANTITY']/oe:list">
                                                    <xsl:element name="xs:element">
                                                        
                                                        <xsl:attribute name="name">
                                                            
                                                            <xsl:choose>
                                                                <xsl:when test="count(parent::node()/oe:list)>1">
                                                                    
                                                                    <xsl:choose>
                                                                        <xsl:when test="oe:units='7.72E+08 rad/h2'">
                                                                            <xsl:text xml:space="default">interval_</xsl:text><xsl:value-of select="translate($interval-type, $ucletters,$lcletters)"/><xsl:text xml:space="default">_angular_acceleration_value</xsl:text>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:call-template name="formatPropertyUnitName">
                                                                                <xsl:with-param name="property-unit">
                                                                                    <xsl:text xml:space="default">interval_</xsl:text><xsl:value-of select="translate($interval-type, $ucletters,$lcletters)"/><xsl:value-of select="oe:units"/>_value</xsl:with-param>
                                                                            </xsl:call-template>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                    
                                                                </xsl:when>
                                                                <xsl:otherwise>value</xsl:otherwise>
                                                            </xsl:choose>
                                                            
                                                        </xsl:attribute>
                                                        
                                                        <xsl:attribute name="minOccurs">0</xsl:attribute><!-- optional to support null values -->
                                                        
                                                        <xsl:call-template name="applyQuantityItemConstraint">
                                                            <xsl:with-param name="currNode" select="."/>
                                                        </xsl:call-template>
                                                        
                                                    </xsl:element>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <!-- other datatype intervals (non-quantity datatype interval) -->
                                            <xsl:otherwise>
                                                <xsl:text xml:space="default">interval_</xsl:text><xsl:value-of select="translate($interval-type, $ucletters,$lcletters)"/><xsl:text xml:space="default">_value</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    
                                    <xsl:element name="xs:element">
                                        
                                        <xsl:attribute name="name">
                                            <xsl:value-of select="$valueName"/>
                                        </xsl:attribute>
                                        
                                        <xsl:attribute name="minOccurs">0</xsl:attribute><!-- optional to support null values -->
                                        
                                        <xsl:choose>
                                            <!-- apply value constraints -->
                                            <xsl:when test="oe:attributes">
                                                <xsl:apply-templates select="."/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <!-- no value constraints -->
                                                <xsl:attribute name="type">oe:<xsl:value-of select="oe:rm_type_name"/></xsl:attribute>
                                            </xsl:otherwise>    
                                        </xsl:choose>
                                        
                                    </xsl:element>
                                </xsl:for-each>
                                <!-- other datatypes (i.e. NOT dv_quantity with multiple C_QUANTITY_ITEMs or dv_interval) -->
                                <xsl:for-each select="oe:attributes[oe:rm_attribute_name='value']/oe:children[
                                    not ( (oe:rm_type_name='DV_QUANTITY') and (count(oe:list)>1) )
                                    and not(starts-with(oe:rm_type_name, 'DV_INTERVAL'))
                                    and not(oe:rm_type_name='DATA_VALUE')]">
                                    <xsl:element name="xs:element">
                                        
                                        <xsl:attribute name="name"><xsl:value-of select="translate(substring-after(oe:rm_type_name,'DV_'), $ucletters,$lcletters)"/>_value</xsl:attribute>
                                        
                                        <xsl:attribute name="minOccurs">0</xsl:attribute><!-- optional to support null values -->
                                        
                                        <!-- sb: 01/10/08 -->
                                        <xsl:choose>
                                            <!-- hf: updated 07 Nov 08 to supports multiple value objects with DV_CODED_TEXT-->
                                            <!-- DV_TEXT / DV_CODED_TEXT if terminology is internal/local then data value is optional because we can obtain the term value from the archetype based on the internal code -->
                                            <xsl:when test="oe:rm_type_name='DV_CODED_TEXT' or oe:rm_type_name='DV_TEXT'">
                                                <xsl:call-template name="constructTextAndCodedTextElementValue">
                                                    <xsl:with-param name="archetypeRoot" select="."/>
                                                    <xsl:with-param name="element-value-object" select="."/>
                                                </xsl:call-template>                                                
                                            </xsl:when>
                                            
                                            <!-- apply value constraints -->
                                            <xsl:when test="oe:attributes">
                                                <xsl:apply-templates select="."/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <!-- no value constraints -->
                                                <xsl:attribute name="type">oe:<xsl:value-of select="oe:rm_type_name"/></xsl:attribute>
                                            </xsl:otherwise>    
                                        </xsl:choose>
                                        <!-- end added -->
                                        
                                    </xsl:element>
                                </xsl:for-each>
                                <!-- DATA_VALUE (datatype not specified) -->
                                <xsl:for-each select="oe:attributes[oe:rm_attribute_name='value']/oe:children[oe:rm_type_name='DATA_VALUE']">
                                    <xsl:element name="xs:element">
                                        
                                        <xsl:attribute name="name">data_value</xsl:attribute>
                                        
                                        <xsl:attribute name="minOccurs">0</xsl:attribute><!-- optional to support null values -->
                                        
                                        <xsl:attribute name="type">oe:DATA_VALUE</xsl:attribute>
                                        
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:when>
                        
                        <!-- sb: modified 11/02/08 handles SINGLE datatype data values -->
                        <xsl:when test="count(oe:attributes[oe:rm_attribute_name='value']/oe:children)=1">
                            
                            <xsl:element name="xs:element">
                                <xsl:attribute name="name">value</xsl:attribute>
                                
                                <xsl:attribute name="minOccurs">0</xsl:attribute><!-- optional to support null values -->
                                
                                <xsl:choose>
                                    
                                    <!-- DV_TEXT / DV_CODED_TEXT
                                        if terminology is internal/local then data value is optional because we can obtain the term value from the archetype based on the internal code -->
                                    <xsl:when test="oe:attributes[oe:rm_attribute_name='value']/oe:children[oe:rm_type_name='DV_CODED_TEXT' or oe:rm_type_name='DV_TEXT']">
                                        
                                        <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                                        <!-- hf: updated 07 Nov 08 to reuse modified template that supports multiple value objects -->
                                        <xsl:call-template name="constructTextAndCodedTextElementValue">
                                            <xsl:with-param name="archetypeRoot" select="."/>
                                            <!--<xsl:with-param name="element-value-context" select="."/>-->
                                            <xsl:with-param name="element-value-object" select="oe:attributes[oe:rm_attribute_name='value']/oe:children"/>                                            
                                        </xsl:call-template>
                                        
                                    </xsl:when>
                                    
                                    <!-- all other data types -->
                                    <!-- sb: modified 04/06/08 to use apply-templates rather than call-template -->
                                    <xsl:when test="not(oe:attributes[oe:rm_attribute_name='value']/oe:children[oe:rm_type_name='DV_CODED_TEXT' or oe:rm_type_name='DV_TEXT'])">
                                        <xsl:apply-templates select="oe:attributes[oe:rm_attribute_name='value']/oe:children"/>
                                    </xsl:when>
                                    
                                    <!-- CATCH all 'unsupported RM types' : creates completely unconstrained element of the specified RM type -->
                                    <xsl:otherwise>
                                        
                                        <xsl:attribute name="type"><xsl:choose>
                                            <xsl:when test="oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:rm_type_name != ''">oe:<xsl:value-of select="oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:rm_type_name"/></xsl:when>
                                            <xsl:otherwise>oe:DATA_VALUE</xsl:otherwise> <!-- avoid type="oe:" error (temporary fix) LT 2007/11/26-->
                                        </xsl:choose></xsl:attribute>
                                        <xsl:attribute name="minOccurs">0</xsl:attribute><!-- optional to support null values -->
                                        
                                    </xsl:otherwise>
                                    
                                </xsl:choose>
                                
                            </xsl:element>
                            
                        </xsl:when>
                        
                        <!-- sb: added 11/02/08 handles ANY datatype (no datatype constrained) -->
                        <xsl:otherwise>
                            <xsl:element name="xs:element">
                                <xsl:attribute name="name">value</xsl:attribute>
                                <xsl:attribute name="type">oe:DATA_VALUE<!-- avoid type="oe:" error (temporary fix) LT 2007/11/26--></xsl:attribute>
                                <xsl:attribute name="minOccurs">0</xsl:attribute><!-- optional to support null values -->
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">null_flavour</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                        <xsl:variable name="nullFlavourCodePhraseXpath" select="oe:attributes[oe:rm_attribute_name='null_flavour']/oe:children[oe:rm_type_name='DV_CODED_TEXT']/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children[oe:rm_type_name='CODE_PHRASE']"/>
                        <xsl:call-template name="constructDvCodedText">
                            <xsl:with-param name="codePhraseXPath" select="$nullFlavourCodePhraseXpath"/>
                        </xsl:call-template>
                    </xsl:element>
                		
                	</xsl:element>
                	
                </xsl:element>
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">
                        <xsl:value-of select="oe:archetype_id/oe:value"/><!-- because this is an ELEMENT archetype ROOT
                            use the archetype ID not the 'at code' of 'at0000'.
                            HF: comment - no XSD should have 'at0000' anywhere as this is the same as the archetype ID which 
                            is more meaningful (the 'at0000' does not get used) -->
                    </xsl:attribute>
                    <xsl:attribute name="name">archetype_node_id</xsl:attribute>
                    <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">ELEMENT</xsl:attribute>
                    <xsl:attribute name="name">type</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
                <!-- sb: added 24/01/08 -->
                <!-- hk: comments as per wiki: the need to specify Element/value type is just as important in the case of refering to the openEHR type as a serialised
                    instance will not have an xsi:type attribute unless it uses an inherited type such as DV_CODED_TEXT when the element value is specified as 
                    DV_TEXT in the schema.  It does however, make it more difficult to find a solution because you can not explicitly specify an additional attribute on 
                    the value XML element because you are referring to an openEHR type unless you extend this type. However, this will not work for DV_TEXT as 
                    an extension of DV_TEXT to add an attribute will branch the inheritence and not allow DV_CODED_TEXT to be substitued in the instance.
                    Therefore an alternate proposal is suggested which should support both usecases. Adding a valueType attribute to the ELEMENT element 
                    specifying the base type specified in the schema. When this is substitued with an inherited type such as DV_CODED_TEXT the valueType will 
                    still be DV_TEXT (although it could be made to be DV_CODED_TEXT but will require an enumeration to define the attribute rather than a fixed 
                    value) while the xsi:type attribute on the value itself will indicated which subtype has been used. -->
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="name">valueType</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="count(oe:attributes[oe:rm_attribute_name='value']/oe:children)>1"><!-- choice datatype so need to specify the valueType (as this is not fixed / obtainable from the schema) -->
                            <xsl:attribute name="use">required</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="is-fixed-attribute-required"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <!-- sb: added 27/02/08 [TMP-458] handle MULTIPLE data type data values -->
                        <xsl:when test="count(oe:attributes[oe:rm_attribute_name='value']/oe:children)>1">
                            <xsl:element name="xs:simpleType">
                                <xsl:element name="xs:restriction">
                                    <xsl:attribute name="base">xs:string</xsl:attribute>
                                    <xsl:for-each select="oe:attributes[oe:rm_attribute_name='value']/oe:children">
                                        <xsl:element name="xs:enumeration">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="oe:rm_type_name"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:element>
                        </xsl:when>
                        <!-- single data type data value only -->
                        <xsl:otherwise>
                            <xsl:attribute name="fixed">
                                <xsl:choose>
                                    <xsl:when test="oe:attributes[oe:rm_attribute_name='value']/oe:children[oe:rm_type_name='DV_CODED_TEXT' or oe:rm_type_name='DV_TEXT']">DV_TEXT</xsl:when>
                                    <xsl:when test="oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:rm_type_name!=''">
                                        <xsl:value-of select="oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:rm_type_name"/>
                                    </xsl:when>
                                    <xsl:otherwise>DATA_VALUE</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <!-- end added -->
            </xsl:element>
            
        </xsl:element>
    </xsl:template>
    <!-- end ELEMENT Archetype root -->

    <!-- ELEMENT (C_COMPLEX_OBJECT) match -->
    <xsl:template match="*[(oe:rm_type_name='ELEMENT') and (@xsi:type='C_COMPLEX_OBJECT')]">
        <xsl:param name="archetypeRoot"/>
        
        <xsl:element name="xs:element">
            
            <!-- call objectElementAttributes -->
            <xsl:call-template name="objectElementAttributes">
                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                <xsl:with-param name="c_object" select="."/>
            </xsl:call-template>
            
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    
                  <!-- SAB added 04-03-08 for TMP-461 to replace call-template 'constructTextAttribute' -->
                   <xsl:call-template name="constructElementName">
                       <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                       <xsl:with-param name="element-name-context" select="."/>
                   </xsl:call-template>
                    
                  <!-- LMT added 29/04/2010 for TMP-1234 choice between ELEMENT.value or ELEMENT.null_flavour
                  		   LMT removed minOccurs=0 attributes on all elements inside this choice as they're no longer required for the optionality between value and null_flavour-->
                  <xsl:element name="xs:choice">
                		
                    <xsl:choose>
                        
                      <!-- handle MULTIPLE data type data values or MULTIPLE C_QUANTITY_ITEMs for a DV_QUANTITY -->
                      <xsl:when test="(count(oe:attributes[oe:rm_attribute_name='value']/oe:children)>1)
                          or (count(oe:attributes[oe:rm_attribute_name='value']/oe:children[oe:rm_type_name='DV_QUANTITY']/oe:list)>1)">
                          <!-- multiple quantity items -->
                          <xsl:for-each select="oe:attributes[oe:rm_attribute_name='value']/oe:children[oe:rm_type_name='DV_QUANTITY']/oe:list">
                              <xsl:element name="xs:element">
                                  
                                  <xsl:attribute name="name">
                                      
                                      <xsl:choose>
                                          <xsl:when test="count(parent::node()/oe:list)>1">
                                              <!-- variable to used to check if the unit starts with a number or not -->
                                              <xsl:variable name="first-char" select="number(substring(oe:units, 1, 1))"/>
                                              
                                              <xsl:choose>
                                                  <xsl:when test="oe:units='7.72E+08 rad/h2'">angular_acceleration_value</xsl:when>
                                                  <!-- check if this unit starts with a number -->
                                                  <xsl:when test="$first-char = 0 or $first-char = 1 or $first-char = 2 or $first-char = 3 or $first-char = 4 or $first-char = 5 or $first-char = 6 or $first-char = 7 or $first-char = 8 or $first-char = 9">
                                                      <xsl:call-template name="formatPropertyUnitName">
                                                          <xsl:with-param name="property-unit">
                                                              <xsl:text xml:space="preserve">_</xsl:text><xsl:value-of select="oe:units"/>_value
                                                          </xsl:with-param>
                                                      </xsl:call-template>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <xsl:call-template name="formatPropertyUnitName">
                                                          <xsl:with-param name="property-unit"><xsl:value-of select="oe:units"/>_value</xsl:with-param>
                                                      </xsl:call-template>
                                                  </xsl:otherwise>
                                              </xsl:choose>
                                              
                                          </xsl:when>
                                          <xsl:otherwise>value</xsl:otherwise>
                                      </xsl:choose>
                                      
                                  </xsl:attribute>

                                  <xsl:call-template name="applyQuantityItemConstraint">
                                      <xsl:with-param name="currNode" select="."/>
                                  </xsl:call-template>
                                  
                              </xsl:element>
                          </xsl:for-each>
                           <!-- multiple INTERVAL type -->
                           <xsl:for-each select="oe:attributes[oe:rm_attribute_name='value']/oe:children[starts-with(oe:rm_type_name, 'DV_INTERVAL')]">
                               
                               <xsl:variable name="valueName">
                                   <xsl:variable name="temp-interval-type">
                                       <xsl:value-of select="substring-after(oe:rm_type_name, 'DV_INTERVAL&lt;DV_')"/>
                                   </xsl:variable>
                                   <xsl:variable name="interval-type">
                                       <xsl:value-of select="substring-before($temp-interval-type, '&gt;')"/>
                                   </xsl:variable>
                                   <!-- check if there are multiple C_QUANTITY_ITEMs for a DV_QUANTITY INTERVAL -->
                                   <xsl:choose>
                                       <!-- applies to quantity-type intervals only -->
                                       <xsl:when test="(contains(oe:rm_type_name, 'DV_QUANTITY')) and
                                           (count(current()[oe:rm_type_name='DV_QUANTITY']/oe:list)>1)">
                                           <!-- multiple quantity items -->
                                           <xsl:for-each select="oe:attributes[oe:rm_attribute_name='value']/oe:children[oe:rm_type_name='DV_QUANTITY']/oe:list">
                                               <xsl:element name="xs:element">
                                                   
                                                   <xsl:attribute name="name">
                                                       
                                                       <xsl:choose>
                                                           <xsl:when test="count(parent::node()/oe:list)>1">
                                                               <xsl:choose>
                                                                   <xsl:when test="oe:units='7.72E+08 rad/h2'">
                                                                       <xsl:text xml:space="default">interval_</xsl:text><xsl:value-of select="translate($interval-type, $ucletters,$lcletters)"/><xsl:text xml:space="default">_angular_acceleration_value</xsl:text>
                                                                   </xsl:when>
                                                                   <xsl:otherwise>
                                                                       <xsl:call-template name="formatPropertyUnitName">
                                                                           <xsl:with-param name="property-unit">
                                                                               <xsl:text xml:space="default">interval_</xsl:text><xsl:value-of select="translate($interval-type, $ucletters,$lcletters)"/><xsl:value-of select="oe:units"/>_value</xsl:with-param>
                                                                       </xsl:call-template>
                                                                   </xsl:otherwise>
                                                               </xsl:choose>

                                                           </xsl:when>
                                                           <xsl:otherwise>value</xsl:otherwise>
                                                       </xsl:choose>
                                                       
                                                   </xsl:attribute>
                                                   
                                                   <xsl:call-template name="applyQuantityItemConstraint">
                                                       <xsl:with-param name="currNode" select="."/>
                                                   </xsl:call-template>
                                                   
                                               </xsl:element>
                                           </xsl:for-each>
                                       </xsl:when>
                                       <!-- other datatype intervals (non-quantity datatype interval) -->
                                       <xsl:otherwise>
                                           <xsl:text xml:space="default">interval_</xsl:text><xsl:value-of select="translate($interval-type, $ucletters,$lcletters)"/><xsl:text xml:space="default">_value</xsl:text>
                                       </xsl:otherwise>
                                   </xsl:choose>
                               </xsl:variable>
                              
                               <xsl:element name="xs:element">
                                   
                                   <xsl:attribute name="name">
                                       <xsl:value-of select="$valueName"/>
                                   </xsl:attribute>
                                   
                                   <xsl:choose>
                                       <!-- apply value constraints -->
                                       <xsl:when test="oe:attributes">
                                           <xsl:apply-templates select="."/>
                                       </xsl:when>
                                       <xsl:otherwise>
                                           <!-- no value constraints -->
                                           <xsl:attribute name="type">oe:<xsl:value-of select="oe:rm_type_name"/></xsl:attribute>
                                       </xsl:otherwise>    
                                   </xsl:choose>
                                   
                               </xsl:element>
                           </xsl:for-each>
                           <!-- other datatypes (i.e. NOT dv_quantity with multiple C_QUANTITY_ITEMs or dv_interval) -->
                           <xsl:for-each select="oe:attributes[oe:rm_attribute_name='value']/oe:children[
                               not ( (oe:rm_type_name='DV_QUANTITY') and (count(oe:list)>1) )
                               and not(starts-with(oe:rm_type_name, 'DV_INTERVAL'))
                               and not(oe:rm_type_name='DATA_VALUE')]">
                               <xsl:element name="xs:element">
                                   
                                   <xsl:attribute name="name"><xsl:value-of select="translate(substring-after(oe:rm_type_name,'DV_'), $ucletters,$lcletters)"/>_value</xsl:attribute>

                                   <!-- sb: 01/10/08 -->
                                   <xsl:choose>
                                       <!-- hf: updated 07 Nov 08 to supports multiple value objects with DV_CODED_TEXT-->
                                       <!-- DV_TEXT / DV_CODED_TEXT if terminology is internal/local then data value is optional because we can obtain the term value from the archetype based on the internal code -->
                                       <xsl:when test="oe:rm_type_name='DV_CODED_TEXT' or oe:rm_type_name='DV_TEXT'">
                                           <xsl:call-template name="constructTextAndCodedTextElementValue">
                                               <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                               <xsl:with-param name="element-value-object" select="."/>
                                           </xsl:call-template>                                                
                                       </xsl:when>
                                       
                                       <!-- apply value constraints -->
                                       <xsl:when test="oe:attributes">
                                           <xsl:apply-templates select="."/>
                                       </xsl:when>
                                       <xsl:otherwise>
                                           <!-- no value constraints -->
                                           <xsl:attribute name="type">oe:<xsl:value-of select="oe:rm_type_name"/></xsl:attribute>
                                       </xsl:otherwise>    
                                   </xsl:choose>
                                   <!-- end added -->
                                   
                               </xsl:element>
                           </xsl:for-each>
                           <!-- DATA_VALUE (datatype not specified) -->
                           <xsl:for-each select="oe:attributes[oe:rm_attribute_name='value']/oe:children[oe:rm_type_name='DATA_VALUE']">
                               <xsl:element name="xs:element">
                                   
                                   <xsl:attribute name="name">data_value</xsl:attribute>
                                   
                                   <xsl:attribute name="type">oe:DATA_VALUE</xsl:attribute>
                                   
                               </xsl:element>
                           </xsl:for-each>
                      </xsl:when>
                      
                      <!-- sb: modified 11/02/08 handles SINGLE datatype data values -->
                      <xsl:when test="count(oe:attributes[oe:rm_attribute_name='value']/oe:children)=1">
                          
                          <xsl:element name="xs:element">
                              <xsl:attribute name="name">value</xsl:attribute>
                          
                              <xsl:choose>
                                  
                                  <!-- DV_TEXT / DV_CODED_TEXT
                                      if terminology is internal/local then data value is optional because we can obtain the term value from the archetype based on the internal code -->
                                  <xsl:when test="oe:attributes[oe:rm_attribute_name='value']/oe:children[oe:rm_type_name='DV_CODED_TEXT' or oe:rm_type_name='DV_TEXT']">
                                      
                                      <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                                      <xsl:call-template name="constructTextAndCodedTextElementValue">
                                          <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                          <!-- hf: updated 07 Nov 08 to reuse modified template that supports multiple value objects -->
                                          <!--<xsl:with-param name="element-value-context" select="oe:attributes[oe:rm_attribute_name='value']"/>-->
                                          <xsl:with-param name="element-value-object" select="oe:attributes[oe:rm_attribute_name='value']/oe:children"/>
                                      </xsl:call-template>
                                  </xsl:when>
                                  
                                  <!-- all other data types -->
                                  <!-- sb: modified 04/06/08 to use apply-templates rather than call-template -->
                                  <xsl:when test="not(oe:attributes[oe:rm_attribute_name='value']/oe:children[oe:rm_type_name='DV_CODED_TEXT' or oe:rm_type_name='DV_TEXT'])">
                                      <xsl:apply-templates select="oe:attributes[oe:rm_attribute_name='value']/oe:children">
                                          <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                      </xsl:apply-templates>
                                  </xsl:when>
                                  
                                  <!-- CATCH all 'unsupported RM types' : creates completely unconstrained element of the specified RM type -->
                                  <xsl:otherwise>
                                      
                                          <xsl:attribute name="type"><xsl:choose>
                                              <xsl:when test="oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:rm_type_name != ''">oe:<xsl:value-of select="oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:rm_type_name"/></xsl:when>
                                              <xsl:otherwise>oe:DATA_VALUE</xsl:otherwise> <!-- avoid type="oe:" error (temporary fix) LT 2007/11/26-->
                                          </xsl:choose></xsl:attribute>
                                      
                                  </xsl:otherwise>
                                  
                              </xsl:choose>
                          
                          </xsl:element>
                          
                      </xsl:when>
                      
                      <!-- sb: added 11/02/08 handles ANY datatype (no datatype constrained) -->
                      <xsl:otherwise>
                          <xsl:element name="xs:element">
                              <xsl:attribute name="name">value</xsl:attribute>
                              <xsl:attribute name="type">oe:DATA_VALUE<!-- avoid type="oe:" error (temporary fix) LT 2007/11/26--></xsl:attribute>
                          </xsl:element>
                      </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">null_flavour</xsl:attribute>
                        <xsl:variable name="nullFlavourCodePhraseXpath" select="oe:attributes[oe:rm_attribute_name='null_flavour']/oe:children[oe:rm_type_name='DV_CODED_TEXT']/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children[oe:rm_type_name='CODE_PHRASE']"/>
                        <xsl:call-template name="constructDvCodedText">
                            <xsl:with-param name="codePhraseXPath" select="$nullFlavourCodePhraseXpath"/>
                        </xsl:call-template>
                    </xsl:element>
                  	
                   </xsl:element>
                </xsl:element>
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">
                        <xsl:value-of select="oe:node_id"/>
                    </xsl:attribute>
                    <xsl:attribute name="name">archetype_node_id</xsl:attribute>
                    <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">ELEMENT</xsl:attribute>
                    <xsl:attribute name="name">type</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
                <!-- sb: added 24/01/08 -->
                <!-- hk: comments as per wiki: the need to specify Element/value type is just as important in the case of refering to the openEHR type as a serialised
                    instance will not have an xsi:type attribute unless it uses an inherited type such as DV_CODED_TEXT when the element value is specified as 
                    DV_TEXT in the schema.  It does however, make it more difficult to find a solution because you can not explicitly specify an additional attribute on 
                    the value XML element because you are referring to an openEHR type unless you extend this type. However, this will not work for DV_TEXT as 
                    an extension of DV_TEXT to add an attribute will branch the inheritence and not allow DV_CODED_TEXT to be substitued in the instance.
                    Therefore an alternate proposal is suggested which should support both usecases. Adding a valueType attribute to the ELEMENT element 
                    specifying the base type specified in the schema. When this is substitued with an inherited type such as DV_CODED_TEXT the valueType will 
                    still be DV_TEXT (although it could be made to be DV_CODED_TEXT but will require an enumeration to define the attribute rather than a fixed 
                    value) while the xsi:type attribute on the value itself will indicated which subtype has been used. -->
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="name">valueType</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="count(oe:attributes[oe:rm_attribute_name='value']/oe:children)>1"><!-- choice datatype so need to specify the valueType (as this is not fixed / obtainable from the schema) -->
                            <xsl:attribute name="use">required</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="is-fixed-attribute-required"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <!-- sb: added 27/02/08 [TMP-458] handle MULTIPLE data type data values -->
                        <xsl:when test="count(oe:attributes[oe:rm_attribute_name='value']/oe:children)>1">
                            <xsl:element name="xs:simpleType">
                                <xsl:element name="xs:restriction">
                                    <xsl:attribute name="base">xs:string</xsl:attribute>
                                    <xsl:for-each select="oe:attributes[oe:rm_attribute_name='value']/oe:children">
                                        <xsl:element name="xs:enumeration">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="oe:rm_type_name"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:element>
                        </xsl:when>
                        <!-- single data type data value only -->
                        <xsl:otherwise>
                            <xsl:attribute name="fixed">
                                <xsl:choose>
                                    <xsl:when test="string-length(oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:rm_type_name)>0">
                                        <xsl:value-of select="oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:rm_type_name"/>
                                    </xsl:when>
                                    <xsl:otherwise>DATA_VALUE</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <!-- end added -->
            </xsl:element>
            
        </xsl:element>
    </xsl:template>
    <!-- end ELEMENT wildcard match -->
    
    <!-- ITEM_SINGLE (C_ARCHETYPE_ROOT) match -->
    <xsl:template match="*[(oe:rm_type_name='ITEM_SINGLE') and (@xsi:type='C_ARCHETYPE_ROOT')]">
        <xsl:param name="archetypeRoot" select="."/>
        
        <xsl:element name="xs:element">
            <xsl:call-template name="objectElementAttributes">
                <xsl:with-param name="archetypeRoot" select="."/>
                <xsl:with-param name="c_object" select="."/>
            </xsl:call-template>
            
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    
                    <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                    <xsl:call-template name="constructElementName">
                        <xsl:with-param name="archetypeRoot" select="."/>
                        <xsl:with-param name="element-name-context" select="."/>
                    </xsl:call-template>
                    
                    <xsl:choose>
                        <!-- contains 'attributes' xml elements -->
                        <xsl:when test="count(oe:attributes)>0">
                            <!-- now process only child nodes -->
                            <!-- apply templates to ITEM_SINGLE.item -->
                            <xsl:for-each select="oe:attributes[oe:rm_attribute_name='item']/oe:children">
                                <xsl:choose>
                                    <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                        <xsl:apply-templates select=".">
                                            <xsl:with-param name="archetypeRoot" select="."/>
                                        </xsl:apply-templates>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select=".">
                                            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                        </xsl:apply-templates>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
                        <xsl:otherwise>
                            <xsl:call-template name="generate-archetype-slot">
                                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                </xsl:element>
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">
                        <xsl:value-of select="oe:archetype_id/oe:value"/>
                    </xsl:attribute>
                    <xsl:attribute name="name">archetype_node_id</xsl:attribute>
                    <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
                
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed"><xsl:value-of select="oe:rm_type_name"/></xsl:attribute>
                    <xsl:attribute name="name">type</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
            </xsl:element>            
        </xsl:element>
                    
    </xsl:template>
    
    <!-- ITEM_SINGLE (C_COMPLEX_OBJECT) match -->
    <xsl:template match="*[(oe:rm_type_name='ITEM_SINGLE') and (@xsi:type='C_COMPLEX_OBJECT')]">
        <xsl:param name="archetypeRoot"/>
        
        <xsl:choose>
            <!-- contains 'attributes' xml elements -->
            <xsl:when test="count(oe:attributes)>0">
                <!-- now process only child nodes -->
                <!-- apply templates to CLUSTER.items -->
                <xsl:for-each select="oe:attributes[oe:rm_attribute_name='item']/oe:children">
                    <xsl:choose>
                        <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="archetypeRoot" select="."/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                            </xsl:apply-templates>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
            <xsl:otherwise>
                <xsl:call-template name="generate-archetype-slot">
                    <xsl:with-param name="currNode" select="."/>
                    <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
                    
    </xsl:template>
    
    <!-- ITEM_TABLE (C_ARCHETYPE_ROOT) match -->
    <xsl:template match="*[(oe:rm_type_name='ITEM_TABLE') and (@xsi:type='C_ARCHETYPE_ROOT')]">
        <xsl:param name="archetypeRoot" select="."/>
        
        <xsl:element name="xs:element">
            <xsl:call-template name="objectElementAttributes">
                <xsl:with-param name="archetypeRoot" select="."/>
                <xsl:with-param name="c_object" select="."/>
            </xsl:call-template>
            
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    
                    <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                    <xsl:call-template name="constructElementName">
                        <xsl:with-param name="archetypeRoot" select="."/>
                        <xsl:with-param name="element-name-context" select="."/>
                    </xsl:call-template>
        
                    <xsl:choose>
                        <!-- contains 'attributes' xml elements -->
                        <xsl:when test="count(oe:attributes)>0">
                            <!-- now process only child nodes -->
                            <!-- apply templates to ITEM_TABLE.rows -->
                            <xsl:for-each select="oe:attributes[oe:rm_attribute_name='rows']/oe:children">
                                <xsl:choose>
                                    <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                        <xsl:apply-templates select=".">
                                            <xsl:with-param name="archetypeRoot" select="."/>
                                        </xsl:apply-templates>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select=".">
                                            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                        </xsl:apply-templates>
                                    </xsl:otherwise>
                                </xsl:choose>                        
                            </xsl:for-each>
                        </xsl:when>
                        <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
                        <xsl:otherwise>
                            <xsl:call-template name="generate-archetype-slot">
                                <xsl:with-param name="archetypeRoot" select="."/>
                                <xsl:with-param name="currNode" select="."/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
        
                </xsl:element>
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">
                        <xsl:value-of select="oe:archetype_id/oe:value"/>
                    </xsl:attribute>
                    <xsl:attribute name="name">archetype_node_id</xsl:attribute>
                    <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
                
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed"><xsl:value-of select="oe:rm_type_name"/></xsl:attribute>
                    <xsl:attribute name="name">type</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
            </xsl:element>            
        </xsl:element>
        
    </xsl:template>

    <!-- ITEM_TABLE (C_COMPLEX_OBJECT) match -->
    <xsl:template match="*[(oe:rm_type_name='ITEM_TABLE') and (@xsi:type='C_COMPLEX_OBJECT')]">
        <xsl:param name="archetypeRoot"/>
        
        <xsl:choose>
            <!-- contains 'attributes' xml elements -->
            <xsl:when test="count(oe:attributes)>0">
                <!-- now process only child nodes -->
                <!-- apply templates to ITEM_TABLE.rows -->
                <xsl:for-each select="oe:attributes[oe:rm_attribute_name='rows']/oe:children">
                    <xsl:choose>
                        <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="archetypeRoot" select="."/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                            </xsl:apply-templates>
                        </xsl:otherwise>
                    </xsl:choose>                        
                </xsl:for-each>
            </xsl:when>
            <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
            <xsl:otherwise>
                <xsl:call-template name="generate-archetype-slot">
                    <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                    <xsl:with-param name="currNode" select="."/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
                    
    </xsl:template>

    <!-- ITEM_TREE/ITEM_LIST (C_ARCHETYPE_ROOT) match -->
    <xsl:template match="*[(oe:rm_type_name='ITEM_TREE' or oe:rm_type_name='ITEM_LIST') and (@xsi:type='C_ARCHETYPE_ROOT')]">
        <xsl:param name="archetypeRoot" select="."/>

        <xsl:element name="xs:element">
            <xsl:call-template name="objectElementAttributes">
                <xsl:with-param name="archetypeRoot" select="."/>
                <xsl:with-param name="c_object" select="."/>
            </xsl:call-template>
            
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    
                    <!-- sb: added 04-03-08 to replace call-template 'constructTextAttribute' -->
                    <xsl:call-template name="constructElementName">
                        <xsl:with-param name="archetypeRoot" select="."/>
                        <xsl:with-param name="element-name-context" select="."/>
                    </xsl:call-template>

                    <xsl:choose>
                        <!-- contains 'attributes' xml elements -->
                        <xsl:when test="count(oe:attributes)>0">
                            
                            <!-- now process only child nodes -->
                            <!-- apply templates to ITEM_TABLE.rows -->
                            <xsl:for-each select="oe:attributes[oe:rm_attribute_name='items']/oe:children">
                                <xsl:choose>
                                    <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                        <xsl:apply-templates select=".">
                                            <xsl:with-param name="archetypeRoot" select="."/>
                                        </xsl:apply-templates>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select=".">
                                            <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                        </xsl:apply-templates>
                                    </xsl:otherwise>
                                </xsl:choose>                        
                            </xsl:for-each>
                            
                        </xsl:when>
                        <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
                        <xsl:otherwise>
                            <xsl:call-template name="generate-archetype-slot">
                                <xsl:with-param name="currNode" select="."/>
                                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:element>
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed">
                        <xsl:value-of select="oe:archetype_id/oe:value"/>
                    </xsl:attribute>
                    <xsl:attribute name="name">archetype_node_id</xsl:attribute>
                    <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
                
                <xsl:element name="xs:attribute">
                    <xsl:attribute name="fixed"><xsl:value-of select="oe:rm_type_name"/></xsl:attribute>
                    <xsl:attribute name="name">type</xsl:attribute>
                    <xsl:call-template name="is-fixed-attribute-required"/>
                </xsl:element>
            </xsl:element>            
        </xsl:element>
   
    </xsl:template>

    <!-- ITEM_TREE/ITEM_LIST (C_COMPLEX_OBJECT) match -->
    <xsl:template match="*[(oe:rm_type_name='ITEM_TREE' or oe:rm_type_name='ITEM_LIST') and (@xsi:type='C_COMPLEX_OBJECT')]">
        <xsl:param name="archetypeRoot"/>
        
        <xsl:choose>
            <!-- contains 'attributes' xml elements -->
            <xsl:when test="count(oe:attributes)>0">
                <!-- now process only child nodes -->
                <!-- apply templates to ITEM_TREE or ITEM_LIST.items -->
                <xsl:for-each select="oe:attributes[oe:rm_attribute_name='items']/oe:children">
                    <xsl:choose>
                        <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="archetypeRoot" select="."/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                            </xsl:apply-templates>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
            <xsl:otherwise>
                <xsl:call-template name="generate-archetype-slot">
                    <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                    <xsl:with-param name="currNode" select="."/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
                    
    </xsl:template>
    
    <!-- CARE_ENTRY -->
    <xsl:template name="careEntryAttributes">
        <xsl:param name="archetypeRoot"/>
        <xsl:if test="$archetypeRoot/oe:attributes[oe:rm_attribute_name='protocol']">
            <xsl:element name="xs:element">
                <xsl:attribute name="name">protocol</xsl:attribute>
                <xsl:attribute name="minOccurs">
                    <xsl:value-of select="$archetypeRoot/oe:attributes[oe:rm_attribute_name='protocol']/oe:existence/oe:lower"/>
                </xsl:attribute>
                <xsl:attribute name="maxOccurs">
                    <xsl:value-of select="$archetypeRoot/oe:attributes[oe:rm_attribute_name='protocol']/oe:existence/oe:upper"/>
                </xsl:attribute>
                <xsl:element name="xs:complexType">
                    <xsl:element name="xs:sequence">
                        
                        <xsl:choose>
                            <!-- contains 'attributes' xml elements -->
                            <xsl:when test="count(oe:attributes)>0">
                                <!-- now process only child nodes -->
                                <!-- apply templates to CARE_ENTRY.protocol -->
                                <xsl:for-each select="oe:attributes[oe:rm_attribute_name='protocol']/oe:children">
                                    <xsl:choose>
                                        <xsl:when test="@xsi:type='C_ARCHETYPE_ROOT'">
                                            <xsl:apply-templates select=".">
                                                <xsl:with-param name="archetypeRoot" select="."/>
                                            </xsl:apply-templates>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates select=".">
                                                <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                            </xsl:apply-templates>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- no archetype_slot specified but is still a slot because its content must not be empty -->
                            <xsl:otherwise>
                                <xsl:call-template name="generate-archetype-slot">
                                    <xsl:with-param name="currNode" select="."/>
                                    <xsl:with-param name="archetypeRoot" select="$archetypeRoot"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:element>
                    <xsl:element name="xs:attribute">
                        <xsl:attribute name="fixed">
                            <xsl:value-of select="$archetypeRoot/oe:attributes[oe:rm_attribute_name='protocol']/oe:children/oe:node_id"/>
                        </xsl:attribute>
                        <xsl:attribute name="name">archetype_node_id</xsl:attribute>
                        <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
                        <xsl:call-template name="is-fixed-attribute-required"/>
                    </xsl:element>
                    <xsl:element name="xs:attribute">
                        <xsl:attribute name="fixed"><xsl:value-of select="$archetypeRoot/oe:attributes[oe:rm_attribute_name='protocol']/oe:children/oe:rm_type_name"/></xsl:attribute>
                        <xsl:attribute name="name">type</xsl:attribute>
                        <xsl:call-template name="is-fixed-attribute-required"/>
                    </xsl:element>
                </xsl:element>
                </xsl:element>
                
        </xsl:if>
        <xsl:if test="$archetypeRoot/oe:attributes[oe:rm_attribute_name='guideline_id']">
            <xsl:element name="xs:element">
                <xsl:attribute name="name">guideline_id</xsl:attribute>
                <xsl:attribute name="type">oe:OBJECT_REF</xsl:attribute>
                <xsl:attribute name="minOccurs">0</xsl:attribute>
                <xsl:attribute name="maxOccurs">1</xsl:attribute>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="entryAttributes">
        <xsl:param name="archetypeRoot"/>
        <!--sb: removed 23/01/08 <xsl:if test="$archetypeRoot/oe:attributes[oe:rm_attribute_name='language']">
            <xsl:element name="xs:element">
                <xsl:attribute name="name">language</xsl:attribute>
                <xsl:attribute name="type">oe:CODE_PHRASE</xsl:attribute>
            </xsl:element>
        </xsl:if>
        <xsl:if test="$archetypeRoot/oe:attributes[oe:rm_attribute_name='encoding']">
            <xsl:element name="xs:element">
                <xsl:attribute name="name">encoding</xsl:attribute>
                <xsl:attribute name="type">oe:CODE_PHRASE</xsl:attribute>
            </xsl:element>
            </xsl:if>-->
        <!-- sb: added 23/01/08 -->
        <xsl:call-template name="constructLanguage"/>
        <xsl:call-template name="constructEncoding"/>
        <!-- end added -->
        <xsl:element name="xs:element">
            <xsl:attribute name="name">subject</xsl:attribute>
            <xsl:attribute name="type">oe:PARTY_SELF</xsl:attribute>
        </xsl:element>
        <xsl:element name="xs:element">
            <xsl:attribute name="name">provider</xsl:attribute>
            <xsl:attribute name="type">oe:PARTY_IDENTIFIED</xsl:attribute>
            <xsl:attribute name="minOccurs">0</xsl:attribute>
            <xsl:attribute name="maxOccurs">1</xsl:attribute>
        </xsl:element>
        
        <xsl:call-template name="constructParticipations">
            <xsl:with-param name="currNode" select="."/>
        </xsl:call-template>
        
        <!-- hf 22/3/2011: removed condition to ensure workflow_id is always provided -->
        <!--<xsl:if test="$archetypeRoot/oe:attributes[oe:rm_attribute_name='workflow_id']">-->
            <xsl:element name="xs:element">
                <xsl:attribute name="name">work_flow_id</xsl:attribute>
                <xsl:attribute name="type">oe:OBJECT_REF</xsl:attribute>
                <xsl:attribute name="minOccurs">0</xsl:attribute>
                <xsl:attribute name="maxOccurs">1</xsl:attribute>
            </xsl:element>
        <!--</xsl:if>-->
    </xsl:template>

    <!-- Gets the archetype node ID for supplied pathable object -->
    <xsl:template name="archetypeNodeIdAttribute">
        <xsl:param name="pathableNode"/>
        <xsl:element name="xs:attribute">
            <xsl:attribute name="fixed">
                <xsl:choose>
                    <xsl:when test="$pathableNode[@xsi:type='C_ARCHETYPE_ROOT']">
                        <xsl:value-of select="$pathableNode/oe:archetype_id/oe:value"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="$pathableNode/oe:node_id"/></xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="name">archetype_node_id</xsl:attribute>
            <xsl:attribute name="type">oe:archetypeNodeId</xsl:attribute>
            <xsl:call-template name="is-fixed-attribute-required"/>
        </xsl:element>
    </xsl:template>
    
    <!-- adds underscore if first character is digit, then removes invalid characters recursively -->
    <xsl:template name="formatElementName">
        <xsl:param name="element-name"/>
        <xsl:variable name="first-char" select="number(substring($element-name, 1, 1))"/><xsl:if test="$first-char = 0 or $first-char = 1 or $first-char = 2 or $first-char = 3 or $first-char = 4 or $first-char = 5 or $first-char = 6 or $first-char = 7 or $first-char = 8 or $first-char = 9">_</xsl:if><xsl:call-template name="replaceSpecialChars">
            <xsl:with-param name="element-name" select="$element-name"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="LookupReplacementCharOrString">
        <xsl:param name="invalid-char"/>
        <xsl:variable name="char-top" select="document($character-map-xml-document-path)/cm:CharacterMapping"/>
        
        <xsl:value-of select="$char-top/cm:CharacterMapping[@id=$invalid-char]/@Text"/>
            
    </xsl:template>
    
    <!-- Replace invalid char -->
    <xsl:template name="replaceSpecialChars">
        <xsl:param name="element-name"/>
        <!-- Lookup the replacement char/string for the invalid character, so that a valid xml element name can be constructed -->
        <xsl:variable name="char-root" select="document($character-map-xml-document-path)/cm:CharacterMapping"/>
                
		<xsl:choose>
			<xsl:when test="contains($element-name, ' ')"><!-- right bracket -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, ' ')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id=' ']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, ' ')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '!')"><!-- exclamation mark -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '!')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='!']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '!')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '?')"><!-- question mark -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '?')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='?']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '?')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test='contains($element-name, "&apos;")'><!-- apostrophe -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select='substring-before($element-name, "&apos;")'/>
			       </xsl:call-template>
			       <xsl:value-of select='$char-root/cm:Char[@id="&apos;"]/@Text'/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select='substring-after($element-name, "&apos;")'/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '`')"><!-- grave accent -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '`')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='`']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '`')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '&quot;')"><!-- quotation mark -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '&quot;')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='&quot;']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '&quot;')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '(')"><!-- left bracket -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '(')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='(']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '(')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, ')')"><!-- right bracket -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, ')')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id=')']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, ')')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '{')"><!-- left brace -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '{')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='{']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '{')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '}')"><!-- right brace -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '}')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='}']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '}')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '[')"><!-- left square bracket -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '[')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='[']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '[')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, ']')"><!-- right square bracket -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, ']')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id=']']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, ']')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '#')"><!-- hash sign -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '#')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='#']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '#')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '%')"><!-- percent sign -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '%')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='%']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '%')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '$')"><!-- dollar sign -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '$')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='$']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '$')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, ',')"><!-- comma -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, ',')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id=',']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, ',')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '.')"><!-- dot -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '.')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='.']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '.')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '/')"><!-- forward slash -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '/')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='/']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '/')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '\')"><!-- back slash -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '\')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='\']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '\')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '|')"><!-- pipe -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '|')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='|']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '|')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '&amp;')"><!-- ampersand -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '&amp;')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='&amp;']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '&amp;')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '+')"><!-- plus sign -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '+')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='+']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '+')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '&lt;')"><!-- less than sign -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '&lt;')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='&lt;']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '&lt;')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '&gt;')"><!-- greater than sign -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '&gt;')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='&gt;']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '&gt;')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '=')"><!-- equal sign -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '=')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='=']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '=')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '@')"><!-- at sign -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '@')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='@']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '@')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, ';')"><!-- semicolon -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, ';')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id=';']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, ';')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, ':')"><!-- colon -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, ':')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id=':']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, ':')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '-')"><!-- hyphen -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '-')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='-']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '-')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '^')"><!-- caret -->
			 <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '^')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='^']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '^')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '~')"><!-- tilda -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '~')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='~']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '~')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:when test="contains($element-name, '*')"><!-- asterisk -->
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-before($element-name, '*')"/>
			       </xsl:call-template>
			       <xsl:value-of select="$char-root/cm:Char[@id='*']/@Text"/>
			       <xsl:call-template name="replaceSpecialChars">
			           <xsl:with-param name="element-name" select="substring-after($element-name, '*')"/>
			       </xsl:call-template>
			   </xsl:when>
			<xsl:otherwise><xsl:value-of select="$element-name" disable-output-escaping="yes"/></xsl:otherwise>
		</xsl:choose>

    </xsl:template>
    
    <xsl:template name="objectElementAttributes">
        <xsl:param name="archetypeRoot"/>
        <xsl:param name="c_object"/>
        <xsl:param name="event-name-to-concatenate"/><!-- This parameter value is required for EVENT/POINT_EVENT/INTERVAL_EVENT. TMP-964 (e.g. concept_name + '_as_Interval_Event' or 'as_Point_Event') -->
        <xsl:param name="ouput-xml-occurrences">yes</xsl:param>
        
        <xsl:attribute name="name">
            <xsl:variable name="explicit-name">
                <xsl:choose>
                    <xsl:when test="$c_object/oe:attributes[oe:rm_attribute_name='name']/oe:children[oe:rm_type_name='DV_TEXT']/oe:attributes[oe:rm_attribute_name='value']/oe:children[translate(oe:rm_type_name, $lcletters, $ucletters)='STRING']/oe:item/oe:list">
                        <xsl:value-of select="$c_object/oe:attributes[oe:rm_attribute_name='name']/oe:children[oe:rm_type_name='DV_TEXT']/oe:attributes[oe:rm_attribute_name='value']/oe:children[translate(oe:rm_type_name, $lcletters, $ucletters)='STRING']/oe:item/oe:list"/>
                    </xsl:when>
                    <xsl:otherwise><!-- possibly a coded text name value constraint -->
                        <xsl:if test="count($c_object/oe:attributes[oe:rm_attribute_name='name']/oe:children[oe:rm_type_name='DV_CODED_TEXT']/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children[translate(oe:rm_type_name, $lcletters, $ucletters)='CODE_PHRASE']/oe:code_list)=1">
                           <xsl:variable name="code-string" select="$c_object/oe:attributes[oe:rm_attribute_name='name']/oe:children[oe:rm_type_name='DV_CODED_TEXT']/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children[translate(oe:rm_type_name, $lcletters, $ucletters)='CODE_PHRASE']/oe:code_list"/>
                           <xsl:if test="$code-string!=''">
                               <xsl:value-of select="$archetypeRoot/oe:term_definitions[@code=$code-string]/oe:items[@id='text']"/>
                           </xsl:if>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>                
            </xsl:variable>
            <xsl:variable name="at-code" select="$c_object/oe:node_id"/>
            <xsl:variable name="concept-name">
                <xsl:choose>
                    <!-- if node has an explicit constrained name in OPT then use that name as an element name
                        otherwise use the name in the root archetype's term definitions
                        (a DV_CODED_TEXT name will not have an explicit constrained name so use default from archetype) -->
                    <!-- updated by LMT 2007/11/28 -->
                    <xsl:when test="$explicit-name!=''">
                        <xsl:call-template name="formatElementName">
                            <xsl:with-param name="element-name" select="$explicit-name"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="formatElementName">
                            <xsl:with-param name="element-name"
                                select="$archetypeRoot/oe:term_definitions[@code=$at-code]/oe:items[@id='text']" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string-length($event-name-to-concatenate)>0"><!-- add EVENT sub-type in name -->
                    <xsl:value-of select="concat($concept-name, $event-name-to-concatenate)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$concept-name"/>
                </xsl:otherwise>
            </xsl:choose>
            
        </xsl:attribute>
        
        <xsl:if test="$ouput-xml-occurrences='yes' and name($c_object)!='definition'">
            <xsl:if test="not($c_object/oe:occurrences/oe:lower='1' and $c_object/oe:occurrences/oe:upper='1')">
                <xsl:attribute name="minOccurs">
                    <xsl:value-of select="$c_object/oe:occurrences/oe:lower"/>
                </xsl:attribute>
            
                <xsl:choose>
                    <xsl:when test="$c_object/oe:occurrences/oe:upper_unbounded='true'">
                        <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="not($c_object/oe:occurrences/oe:upper='1')">
                        <xsl:attribute name="maxOccurs">
                            <xsl:value-of select="$c_object/oe:occurrences/oe:upper"/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
            
    </xsl:template>
    
    <xsl:template name="generate-archetype-slot">
        <xsl:param name="archetypeRoot"/>
        <xsl:param name="currNode"/> 
        
        <xsl:element name="xs:element">
            
            <xsl:attribute name="name">
                <xsl:choose>
                    <xsl:when test="$currNode/oe:node_id!=''"><!-- is a named slot -->
                        <xsl:variable name="at-code" select="$currNode/oe:node_id"/>
                        <xsl:call-template name="formatElementName">
                            <xsl:with-param name="element-name" select="$archetypeRoot/oe:term_definitions[@code=$at-code]/oe:items[@id='text']" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise><!-- unnamed slot -->
                        <xsl:choose>
                            <xsl:when test="$currNode/oe:rm_type_name='ELEMENT'"><xsl:text>item</xsl:text></xsl:when>
                            <xsl:when test="$currNode/oe:rm_type_name='ITEM_TABLE'"><xsl:text>rows</xsl:text></xsl:when>
                            <xsl:otherwise><xsl:text>items</xsl:text></xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            
            <!-- lower occurrences -->
            <xsl:choose>
                <xsl:when test="$currNode/oe:occurrences/oe:lower='1'">
                    <xsl:attribute name="minOccurs">1</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="minOccurs">0</xsl:attribute>                    
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- upper occurrences -->
            <xsl:choose>
                <xsl:when test="$currNode/oe:occurrences/oe:upper='1'">
                    <xsl:attribute name="maxOccurs">1</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>                    
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    <xsl:element name="xs:any">
                        <xsl:attribute name="processContents">lax</xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            
        </xsl:element>
        
    </xsl:template>
       
    <xsl:template name="constructDvText">
        <xsl:param name="dv-text-name"/>
        <xsl:param name="text-value"/>
        <xsl:param name="default-text-value"/>
        <xsl:element name="xs:element">
            <xsl:attribute name="name"><xsl:value-of select="$dv-text-name"/></xsl:attribute>
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">value</xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="$text-value and $text-value!=''">
                                <xsl:attribute name="fixed"><xsl:value-of select="$text-value"/></xsl:attribute>                                
                            </xsl:when>
                            <xsl:when test="$default-text-value">
                                <xsl:attribute name="default"><xsl:value-of select="$default-text-value"/></xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:attribute name="type">xs:string</xsl:attribute>
                    </xsl:element>
                    <!-- sb added: 22/01/08 -->
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">defining_code</xsl:attribute>
                        <xsl:attribute name="type">oe:CODE_PHRASE</xsl:attribute>
                        <xsl:attribute name="minOccurs">0</xsl:attribute>
                    </xsl:element>
                    <!-- end add -->
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- added 06/02/09 (SB-D) - e.g. for use in null_flavours -->
    <xsl:template name="constructDvCodedText">
        <xsl:param name="codePhraseXPath"/>
        
        <xsl:choose>
            <!-- constrained DV_CODED_TEXT -->
            <xsl:when test="count($codePhraseXPath/oe:code_list)>0">
                <xsl:element name="xs:complexType">
                    <xsl:element name="xs:sequence">
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">value</xsl:attribute>
                            <xsl:attribute name="type">xs:string</xsl:attribute>
                        </xsl:element>
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">defining_code</xsl:attribute>
                            <xsl:element name="xs:complexType">
                                <xsl:element name="xs:sequence">
                                    <xsl:element name="xs:element">
                                        <xsl:attribute name="name">terminology_id</xsl:attribute>
                                        <xsl:element name="xs:complexType">
                                            <xsl:element name="xs:sequence">
                                                <xsl:element name="xs:element">
                                                    <xsl:attribute name="name">value</xsl:attribute>
                                                    <xsl:attribute name="fixed"><xsl:value-of select="$codePhraseXPath/oe:terminology_id/oe:value"/></xsl:attribute>
                                                    <xsl:attribute name="type">xs:token</xsl:attribute>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="xs:element">
                                        <xsl:attribute name="name">code_string</xsl:attribute>
                                        
                                        <xsl:choose>
                                            <!-- DV_CODED_TEXT constraint with more than 1 allowable value -->
                                            <xsl:when test="count($codePhraseXPath/oe:code_list)>1">
                                                
                                                <xsl:element name="xs:simpleType">
                                                    <xsl:element name="xs:restriction">
                                                        <xsl:attribute name="base">xs:string</xsl:attribute>
                                                
                                                        <xsl:for-each select="$codePhraseXPath/oe:code_list">
                                                            <xsl:element name="xs:enumeration">
                                                                <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                                            </xsl:element>                                                            
                                                        </xsl:for-each>
                                                    
                                                    </xsl:element>
                                                </xsl:element>
                                                
                                            </xsl:when>
                                            <!-- DV_CODED_TEXT constraint with only 1 allowable value -->
                                            <xsl:when test="count($codePhraseXPath/oe:code_list)=1">
                                                
                                                <xsl:attribute name="type">xs:string</xsl:attribute>
                                                <xsl:attribute name="fixed"><xsl:value-of select="$codePhraseXPath/oe:code_list"/></xsl:attribute>
                                                
                                            </xsl:when>
                                        </xsl:choose>                 
                                            
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
            </xsl:when>
            <!-- unconstrained DV_CODED_TEXT -->
            <xsl:otherwise>
                <xsl:attribute name="type">oe:DV_CODED_TEXT</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <!-- sb: new logic 04/03/08 to construct DV_TEXT and DV_CODED_TEXT VALUE element for LOCATABLE ELEMENT -->
    <!-- hf: updated 07 Nov 08 to supports multiple value objects -->
    <xsl:template name="constructTextAndCodedTextElementValue" >        
        <xsl:param name="archetypeRoot"/>
        <!--<xsl:param name="element-value-context"/>--><!-- pointer to this current element value attribute node -->
        <xsl:param name="element-value-object"/><!-- pointer to this current element value child object.-->
        
        <xsl:choose>
            
            <!-- DV_TEXT Element Value -->
            <!--<xsl:when test="$element-value-context/oe:children/oe:rm_type_name='DV_TEXT'">-->
            <xsl:when test="$element-value-object/oe:rm_type_name='DV_TEXT'">
                
                <xsl:choose>
                    <!-- DV_TEXT has constrained list of text values -->         
                    <xsl:when test="$element-value-object[oe:rm_type_name='DV_TEXT']/oe:attributes[oe:rm_attribute_name='value']/oe:children[translate(oe:rm_type_name, $lcletters, $ucletters)='STRING']/oe:item[@xsi:type='C_STRING']/oe:list">
                        <xsl:element name="xs:complexType">
                            <xsl:element name="xs:sequence">
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">value</xsl:attribute>
                                    
                                    <xsl:choose>
                                        
                                        <xsl:when test="count($element-value-object[oe:rm_type_name='DV_TEXT']/oe:attributes[oe:rm_attribute_name='value']/oe:children[translate(oe:rm_type_name, $lcletters, $ucletters)='STRING']/oe:item[@xsi:type='C_STRING']/oe:list)>1">
                                            <xsl:element name="xs:simpleType">
                                                <xsl:element name="xs:restriction">
                                                    <xsl:attribute name="base">xs:string</xsl:attribute>
                                                    
                                                    <xsl:for-each select="$element-value-object[oe:rm_type_name='DV_TEXT']/oe:attributes[oe:rm_attribute_name='value']/oe:children[translate(oe:rm_type_name, $lcletters, $ucletters)='STRING']/oe:item[@xsi:type='C_STRING']/oe:list">
                                                        <xsl:element name="xs:enumeration">
                                                            <xsl:attribute name="value">
                                                                <xsl:value-of select="."/>
                                                            </xsl:attribute>
                                                        </xsl:element>
                                                    </xsl:for-each>
                                                    
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:when test="count($element-value-object[oe:rm_type_name='DV_TEXT']/oe:attributes[oe:rm_attribute_name='value']/oe:children[translate(oe:rm_type_name, $lcletters, $ucletters)='STRING']/oe:item[@xsi:type='C_STRING']/oe:list)=1">
                                            <xsl:attribute name="fixed"><xsl:value-of select="$element-value-object[oe:rm_type_name='DV_TEXT']/oe:attributes[oe:rm_attribute_name='value']/oe:children[translate(oe:rm_type_name, $lcletters, $ucletters)='STRING']/oe:item[@xsi:type='C_STRING']/oe:list"/></xsl:attribute>
                                            <xsl:attribute name="type">xs:string</xsl:attribute>
                                        </xsl:when>
                                    
                                    </xsl:choose>
                                    
                                </xsl:element>
                                
                                <!-- TMP-961 add optional 'mappings' for constrained DV_TEXT valueset-->
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">mappings</xsl:attribute>
                                    <xsl:attribute name="type">oe:TERM_MAPPING</xsl:attribute>
                                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                                    <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                                </xsl:element>
                                
                            </xsl:element>
                        </xsl:element>
                        
                    </xsl:when>
                    <!-- no constraint applied -->
                    <xsl:otherwise>
                        <xsl:attribute name="type">oe:DV_TEXT</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:when>
            
            <!-- DV_CODED_TEXT Element Value from EXTERNAL terminology-->
            <!-- <xsl:when test="$element-value-context/oe:children[oe:rm_type_name='DV_CODED_TEXT']/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children[@xsi:type='CONSTRAINT_REF']"> -->
            <xsl:when test="$element-value-object[oe:rm_type_name='DV_CODED_TEXT']/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children[@xsi:type='C_CODE_REFERENCE']">                    
                <xsl:attribute name="type">oe:DV_CODED_TEXT</xsl:attribute>
            </xsl:when>
            
            <!-- DV_CODED_TEXT Element Value from LOCAL terminology-->
            <xsl:otherwise>
                <!--<xsl:element name="xs:element">
                    <xsl:attribute name="name">value</xsl:attribute>
                    <xsl:attribute name="minOccurs">0</xsl:attribute>--><!-- optional to support null values -->
                
                <xsl:element name="xs:complexType">
                    <xsl:element name="xs:sequence">
                        
                        <!-- decide if value - value is to be optional or mandatory -->
                        <xsl:choose>
                            
                            <!-- LOCAL terminology used and constrained set of valid code_strings -->
                            <xsl:when test="string-length($element-value-object/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list)>0">
                                
                                <!-- value string is optional -->
                                <!-- sb: note 30/01/08 any string value is allowed here as it will be replaced by a valid openEHR value that matches the atcode/codestring 
                                    when committed as an openEHR instance, but is optional because the atcode is the key value used as the source of truth. -->
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">value</xsl:attribute>
                                    <xsl:attribute name="type">xs:string</xsl:attribute>
                                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                                </xsl:element>
                                
                            </xsl:when>
                            
                            <!-- LOCAL terminology used and there are NO constrained set of valid code_strings specified for some reason -->
                            <xsl:otherwise>
                                <!-- value string is mandatory -->
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">value</xsl:attribute>
                                    <xsl:attribute name="type">xs:string</xsl:attribute>
                                </xsl:element>
                            </xsl:otherwise>
                            
                        </xsl:choose>
                        
                        <!-- TMP-957 add optional 'mappings' for constrained internal codeset -->
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">mappings</xsl:attribute>
                            <xsl:attribute name="type">oe:TERM_MAPPING</xsl:attribute>
                            <xsl:attribute name="minOccurs">0</xsl:attribute>
                            <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                        </xsl:element>
                        
                        <!-- value - defining_code is mandatory -->
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">defining_code</xsl:attribute>
                            <xsl:element name="xs:complexType">
                                <xsl:element name="xs:sequence">
                                    <xsl:element name="xs:element">
                                        <xsl:attribute name="name">terminology_id</xsl:attribute>
                                        <xsl:element name="xs:complexType">
                                            <xsl:element name="xs:sequence">
                                                <xsl:element name="xs:element">
                                                    <xsl:attribute name="name">value</xsl:attribute>
                                                    <xsl:attribute name="fixed">local</xsl:attribute>
                                                    <xsl:attribute name="type">xs:token</xsl:attribute>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:element>
                                    
                                    <xsl:choose>
                                        
                                        <!-- LOCAL terminology used and there are NO constrained set of valid code_strings specified for some reason -->
                                        <xsl:when test="string-length($element-value-object/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list)>0">
                                            <!-- code_string is mandatory with enumeration of valid values -->
                                            <xsl:element name="xs:element">
                                                <xsl:attribute name="name">code_string</xsl:attribute>
                                                
                                                <xsl:choose>
                                                    <xsl:when test="count($element-value-object/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list)>1">
                                                        <xsl:element name="xs:simpleType">
                                                            <xsl:element name="xs:restriction">
                                                                <xsl:attribute name="base">xs:string</xsl:attribute>
                                                                
                                                                <xsl:for-each select="$element-value-object/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list">
                                                                    <xsl:element name="xs:enumeration">
                                                                        <xsl:attribute name="value">
                                                                            <xsl:value-of select="."/>
                                                                        </xsl:attribute>
                                                                    </xsl:element><xsl:text disable-output-escaping="yes">&lt;!-- Value = </xsl:text><xsl:value-of select="$archetypeRoot/oe:term_definitions[@code=current()]/oe:items[@id='text']"/><xsl:text disable-output-escaping="yes"> --&gt;</xsl:text>
                                                                </xsl:for-each>
                                                                
                                                            </xsl:element>
                                                        </xsl:element>
                                                    </xsl:when>
                                                    <xsl:when test="count($element-value-object/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list)=1">
                                                        <xsl:attribute name="fixed"><xsl:value-of select="$element-value-object/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list"/></xsl:attribute>
                                                        <xsl:attribute name="type">xs:string</xsl:attribute>
                                                    </xsl:when>
                                                </xsl:choose>
                                                
                                            </xsl:element><xsl:if test="count($element-value-object/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list)=1"><xsl:text disable-output-escaping="yes">&lt;!-- Value = </xsl:text><xsl:value-of select="$archetypeRoot/oe:term_definitions[@code=$element-value-object/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list]/oe:items[@id='text']"/><xsl:text disable-output-escaping="yes"> --&gt;</xsl:text></xsl:if>
                                        </xsl:when>
                                        
                                        <!-- code_string is mandatory with NO enumeration -->
                                        <xsl:otherwise>
                                            <xsl:element name="xs:element">
                                                <xsl:attribute name="name">code_string</xsl:attribute>
                                                <xsl:attribute name="type">xs:string</xsl:attribute>
                                            </xsl:element>
                                        </xsl:otherwise>
                                        
                                    </xsl:choose>
                                    
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                        
                    </xsl:element>
                </xsl:element>
                <!--                    </xsl:element>-->
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
    
    <!-- sb: new logic 04/03/08 to construct NAME element for LOCATABLE ELEMENT -->
    <xsl:template name="constructElementName">
        
        <xsl:param name="archetypeRoot"/>
        <xsl:param name="element-name-context"/><!-- pointer to this current element name xml node context. -->
        
        <xsl:element name="xs:element">
            <xsl:attribute name="name">name</xsl:attribute>
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    <xsl:element name="xs:element">
                        
                        <xsl:attribute name="name">value</xsl:attribute>     
                        <xsl:attribute name="type">xs:string</xsl:attribute>
                        
                        <xsl:choose>
                            <!-- template constrained element name as fixed value -->
                            <xsl:when test="string-length($element-name-context/oe:attributes[oe:rm_attribute_name='name']/oe:children/oe:attributes[oe:rm_attribute_name='value']/oe:children[translate(oe:rm_type_name, $lcletters, $ucletters)='STRING']/oe:item/oe:list)>0">
                                <xsl:attribute name="fixed">
                                    <xsl:value-of select="$element-name-context/oe:attributes[oe:rm_attribute_name='name']/oe:children/oe:attributes[oe:rm_attribute_name='value']/oe:children[translate(oe:rm_type_name, $lcletters, $ucletters)='STRING']/oe:item/oe:list"/>
                                </xsl:attribute>
                            </xsl:when>
                            <!-- runtime name constraint exists but 'default' not specified at this stage in OPT -->
                            <xsl:when test="string-length($element-name-context/oe:attributes[oe:rm_attribute_name='name']/oe:children/oe:attributes/oe:children/oe:code_list)>0">
                                <!-- do not specify any default or fixed value -->
                                <!-- optional element name value -->
                                <!-- sb: note 30/01/08 any string value is allowed here as it will be replaced by a valid openEHR value that matches the atcode/codestring 
                                when committed as an openEHR instance, but is optional because the atcode is the key value used as the source of truth. -->
                                <xsl:attribute name="minOccurs">0</xsl:attribute>
                            </xsl:when>
                            <!-- use archetype constrained name as default -->
                            <xsl:otherwise>
                                <xsl:attribute name="default">
                                    <xsl:variable name="at-code" select="$element-name-context/oe:node_id"/>
                                    <xsl:value-of select="$archetypeRoot/oe:term_definitions[@code=$at-code]/oe:items[@id='text']"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        </xsl:element>
                        <xsl:choose>
                            
                            <!-- DV_TEXT Element Name -->
                            <xsl:when test="$element-name-context/oe:attributes[oe:rm_attribute_name='name']/oe:children/oe:rm_type_name='DV_TEXT'">
                                
                                <!-- create an optional mappings code -->
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">mappings</xsl:attribute>
                                    <xsl:attribute name="type">oe:TERM_MAPPING</xsl:attribute>
                                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                                    <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                                </xsl:element>
                                
                                <!-- create an optional defining_code -->
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">defining_code</xsl:attribute>
                                    <xsl:attribute name="type">oe:CODE_PHRASE</xsl:attribute>
                                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                                </xsl:element>
                                
                            </xsl:when>
                            
                            <!-- DV_CODED_TEXT Element Name by Runtime Name Constraints.
                                - runtime name constraints with set of allowable values specified. -->
                            <xsl:when test="($element-name-context/oe:attributes[oe:rm_attribute_name='name']/oe:children/oe:rm_type_name='DV_CODED_TEXT')
                                and (string-length($element-name-context/oe:attributes[oe:rm_attribute_name='name']/oe:children/oe:attributes/oe:children/oe:code_list)>0)">
                                
                                <!-- create an optional defining_code -->
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">mappings</xsl:attribute>
                                    <xsl:attribute name="type">oe:TERM_MAPPING</xsl:attribute>
                                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                                    <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                                </xsl:element>
                                
                                <!-- element name - defining code is mandatory -->
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">defining_code</xsl:attribute>
                                    <xsl:element name="xs:complexType">
                                        <xsl:element name="xs:sequence">
                                            <xsl:element name="xs:element">
                                                <xsl:attribute name="name">terminology_id</xsl:attribute>
                                                    <xsl:element name="xs:complexType">
                                                        <xsl:element name="xs:sequence">
                                                            <xsl:element name="xs:element">
                                                                <xsl:attribute name="name">value</xsl:attribute>
                                                                <xsl:attribute name="fixed">local</xsl:attribute>
                                                                <xsl:attribute name="type">xs:token</xsl:attribute>
                                                            </xsl:element>
                                                        </xsl:element>
                                                    </xsl:element>
                                            </xsl:element>
                                            <xsl:element name="xs:element">
                                                <xsl:attribute name="name">code_string</xsl:attribute>
                                                
                                                <xsl:choose>
                                                    <xsl:when test="count($element-name-context/oe:attributes[oe:rm_attribute_name='name']/oe:children/oe:attributes/oe:children/oe:code_list)>1">
                                                        <!-- NOTE: default element names not yet implemented in OPT, otherwise it would be implemented using the xml 'default' attribute -->
                                                        <xsl:element name="xs:simpleType">
                                                            <xsl:element name="xs:restriction">
                                                                <xsl:attribute name="base">xs:string</xsl:attribute>
                                                                
                                                                <xsl:for-each select="$element-name-context/oe:attributes[oe:rm_attribute_name='name']/oe:children/oe:attributes/oe:children/oe:code_list">
                                                                    <xsl:element name="xs:enumeration">
                                                                        <xsl:attribute name="value">
                                                                            <xsl:value-of select="."/>
                                                                        </xsl:attribute>
                                                                    </xsl:element>
                                                                </xsl:for-each>
                                                                
                                                            </xsl:element>
                                                        </xsl:element>
                                                    </xsl:when>
                                                    <xsl:when test="count($element-name-context/oe:attributes[oe:rm_attribute_name='name']/oe:children/oe:attributes/oe:children/oe:code_list)=1">
                                                        <xsl:attribute name="fixed"><xsl:value-of select="$element-name-context/oe:attributes[oe:rm_attribute_name='name']/oe:children/oe:attributes/oe:children/oe:code_list"/></xsl:attribute>
                                                        <xsl:attribute name="type">xs:string</xsl:attribute>
                                                    </xsl:when>
                                                </xsl:choose>
                                                
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                                
                            </xsl:when>
                            
                            <!-- DV_CODED_TEXT Element Name by either:
                                1. External terminology (i.e. defining code in OPT is of type 'CONSTRAINT_REF') OR,
                                2. Runtime Name Constraints with NO set of allowable values specified for some reason. -->
                            <xsl:when test="($element-name-context/oe:attributes[oe:rm_attribute_name='name']/oe:children[oe:rm_type_name='DV_CODED_TEXT']/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children[@xsi:type='C_CODE_REFERENCE'])
                                or ( ($element-name-context/oe:attributes[oe:rm_attribute_name='name']/oe:children[oe:rm_type_name='DV_CODED_TEXT']) 
                                            and 
                                    ( (count($element-name-context/oe:attributes[oe:rm_attribute_name='name']/oe:children[oe:rm_type_name='DV_CODED_TEXT']/oe:attributes/oe:children/oe:code_list)=0)
                                    or
                                    (string-length($element-name-context/oe:attributes[oe:rm_attribute_name='name']/oe:children[oe:rm_type_name='DV_CODED_TEXT']/oe:attributes/oe:children/oe:code_list)>0) ) )">
                                
                                <!-- create an optional defining_code -->
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">mappings</xsl:attribute>
                                    <xsl:attribute name="type">oe:TERM_MAPPING</xsl:attribute>
                                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                                    <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                                </xsl:element>
                                
                                <!-- name - value is mandatory (use xml schema default value = mandatory if none specified) -->
                                <!-- name - defining code is mandatory -->
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">defining_code</xsl:attribute>
                                    <xsl:attribute name="type">oe:CODE_PHRASE</xsl:attribute>
                                </xsl:element>
                                
                            </xsl:when>
                            
                            <xsl:otherwise>
                                
                                <!-- create an optional defining_code -->
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">mappings</xsl:attribute>
                                    <xsl:attribute name="type">oe:TERM_MAPPING</xsl:attribute>
                                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                                    <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                                </xsl:element>
                                
                                <!-- name - value is mandatory (use xml schema default value = mandatory if none specified) -->
                                <!-- name - defining code is optional -->
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">defining_code</xsl:attribute>
                                    <xsl:attribute name="type">oe:CODE_PHRASE</xsl:attribute>
                                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                                </xsl:element>
                                
                            </xsl:otherwise>
                            
                        </xsl:choose>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="constructCodePhrase">
        <xsl:param name="code-phrase-name"/>
        <xsl:param name="terminology-id"/>
        <xsl:param name="code-string"/>
        <xsl:element name="xs:element">
            <xsl:attribute name="name"><xsl:value-of select="$code-phrase-name"/></xsl:attribute>
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">terminology_id</xsl:attribute>
                        <xsl:element name="xs:complexType">
                            <xsl:element name="xs:sequence">
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">value</xsl:attribute>
                                    <xsl:attribute name="fixed"><xsl:value-of select="$terminology-id"/></xsl:attribute>
                                    <xsl:attribute name="type">xs:token</xsl:attribute>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">code_string</xsl:attribute>
                            <xsl:attribute name="fixed"><xsl:value-of select="$code-string"/></xsl:attribute>
                        <xsl:attribute name="type">xs:string</xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- sb: added 23/01/08 to construct 'language' attribute for ENTRY -->
    <xsl:template name="constructLanguage">
        <xsl:element name="xs:element">
            <xsl:attribute name="name">language</xsl:attribute>
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">terminology_id</xsl:attribute>
                        <xsl:element name="xs:complexType">
                            <xsl:element name="xs:sequence">
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">value</xsl:attribute>
                                    <xsl:attribute name="fixed">ISO_639-1</xsl:attribute>
                                    <xsl:attribute name="type">xs:token</xsl:attribute>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">code_string</xsl:attribute>
                        <xsl:attribute name="default">en</xsl:attribute>
                        <xsl:attribute name="type">xs:string</xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- sb: added 23/01/08 to construct 'encoding' attribute for ENTRY -->
    <xsl:template name="constructEncoding">
        <xsl:element name="xs:element">
            <xsl:attribute name="name">encoding</xsl:attribute>
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">terminology_id</xsl:attribute>
                        <xsl:element name="xs:complexType">
                            <xsl:element name="xs:sequence">
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">value</xsl:attribute>
                                    <xsl:attribute name="fixed">IANA_character-sets</xsl:attribute>
                                    <xsl:attribute name="type">xs:token</xsl:attribute>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">code_string</xsl:attribute>
                        <xsl:attribute name="default">UTF-8</xsl:attribute>
                        <xsl:attribute name="type">xs:string</xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- sb: added 23/01/08 -->
    <xsl:template name="constructTerritory">
        <xsl:element name="xs:element">
            <xsl:attribute name="name">territory</xsl:attribute>
            <xsl:element name="xs:complexType">
                <xsl:element name="xs:sequence">
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">terminology_id</xsl:attribute>
                        <xsl:element name="xs:complexType">
                            <xsl:element name="xs:sequence">
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">value</xsl:attribute>
                                    <xsl:attribute name="fixed">ISO_3166-1</xsl:attribute>
                                    <xsl:attribute name="type">xs:token</xsl:attribute>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">code_string</xsl:attribute>
                    	  <xsl:if test="$default-territory-code and $default-territory-code!=''"><xsl:attribute name="default"><xsl:value-of select="$default-territory-code"/></xsl:attribute></xsl:if>
                        <xsl:attribute name="type">xs:string</xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- sb: added 06/03/08 TMP-463 -->
    <xsl:template name="replaceActionArchetypeIdSpecialChars">
        <xsl:param name="element-name"/>
        
        <xsl:choose>
            
            <!-- remove forward slashes -->
            <xsl:when test="contains($element-name, '/')">
                <xsl:call-template name="replaceActionArchetypeIdSpecialChars">
                    <xsl:with-param name="element-name" select="substring-before($element-name, '/')"/>
                </xsl:call-template>
                <xsl:call-template name="replaceActionArchetypeIdSpecialChars">
                    <xsl:with-param name="element-name" select="substring-after($element-name, '/')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- remove backward slashes -->
            <xsl:when test="contains($element-name, '\')">
                <xsl:call-template name="replaceActionArchetypeIdSpecialChars">
                    <xsl:with-param name="element-name" select="substring-before($element-name, '\')"/>
                </xsl:call-template>
                <xsl:call-template name="replaceActionArchetypeIdSpecialChars">
                    <xsl:with-param name="element-name" select="substring-after($element-name, '\')"/>
                </xsl:call-template>
            </xsl:when>
            
            <xsl:otherwise><xsl:value-of select="$element-name" disable-output-escaping="yes"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- sb: added 28/04/08 [TMP-546] - implemented 04/06/08  - revised 14/08/08 -->
    <xsl:template match="oe:children[oe:rm_type_name='DV_COUNT']">
         
         <xsl:choose>
             <!-- constraint exists -->
             <xsl:when test="oe:attributes['magnitude']/oe:children/oe:item">
                 <xsl:element name="xs:complexType">
                     <xsl:element name="xs:sequence">
                         
                         <xsl:call-template name="generate-DV-QUANTIFIED-elements"/>
                         
                         <xsl:element name="xs:element">
                             <xsl:attribute name="name">magnitude</xsl:attribute>
                             
                             <xsl:choose>
                                 <xsl:when test="oe:attributes['magnitude']/oe:children/oe:item/oe:list">
                                     <xsl:element name="xs:simpleType">
                                         <xsl:element name="xs:restriction">
                                             <xsl:attribute name="base">xs:int</xsl:attribute>
                                             <xsl:for-each select="oe:attributes['magnitude']/oe:children/oe:item/oe:list">
                                                 <xsl:element name="xs:enumeration">
                                                     <xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
                                                 </xsl:element>
                                             </xsl:for-each>
                                         </xsl:element>
                                     </xsl:element>
                                 </xsl:when>
                                 <xsl:when test="oe:attributes['magnitude']/oe:children/oe:item/oe:range">
                                     <xsl:element name="xs:simpleType">
                                         <xsl:element name="xs:restriction">
                                             <xsl:attribute name="base">xs:int</xsl:attribute>
                                             
                                             <!-- lower range -->
                                             <xsl:choose>
                                                 <xsl:when test="oe:attributes['magnitude']/oe:children/oe:item/oe:range/oe:lower
                                                     and oe:attributes['magnitude']/oe:children/oe:item/oe:range/oe:lower_included='true'">
                                                     <xsl:element name="xs:minInclusive">
                                                         <xsl:attribute name="value">
                                                             <xsl:value-of select="oe:attributes['magnitude']/oe:children/oe:item/oe:range/oe:lower"/>
                                                         </xsl:attribute>
                                                     </xsl:element>
                                                 </xsl:when>
                                                 <xsl:when test="oe:attributes['magnitude']/oe:children/oe:item/oe:range/oe:lower
                                                     and oe:attributes['magnitude']/oe:children/oe:item/oe:range/oe:lower_included='false'">
                                                     <xsl:element name="xs:minExclusive">
                                                         <xsl:attribute name="value">
                                                             <xsl:value-of select="oe:attributes['magnitude']/oe:children/oe:item/oe:range/oe:lower"/>
                                                         </xsl:attribute>
                                                     </xsl:element>
                                                 </xsl:when>
                                             </xsl:choose>
                                             
                                             <!-- upper range -->
                                             <xsl:choose>
                                                 <xsl:when test="oe:attributes['magnitude']/oe:children/oe:item/oe:range/oe:upper
                                                     and oe:attributes['magnitude']/oe:children/oe:item/oe:range/oe:upper_included='true'">
                                                     <xsl:element name="xs:maxInclusive">
                                                         <xsl:attribute name="value">
                                                             <xsl:value-of select="oe:attributes['magnitude']/oe:children/oe:item/oe:range/oe:upper"/>
                                                         </xsl:attribute>
                                                     </xsl:element>
                                                 </xsl:when>
                                                 <xsl:when test="oe:attributes['magnitude']/oe:children/oe:item/oe:range/oe:upper
                                                     and oe:attributes['magnitude']/oe:children/oe:item/oe:range/oe:upper_included='false'">
                                                     <xsl:element name="xs:maxExclusive">
                                                         <xsl:attribute name="value">
                                                             <xsl:value-of select="oe:attributes['magnitude']/oe:children/oe:item/oe:range/oe:upper"/>
                                                         </xsl:attribute>
                                                     </xsl:element>
                                                 </xsl:when>
                                             </xsl:choose>
                                             
                                         </xsl:element>
                                     </xsl:element>
                                 </xsl:when>
                             </xsl:choose>
                             
                         </xsl:element>
                     </xsl:element>
                 </xsl:element>
             </xsl:when>
             <!-- unconstrained -->
             <xsl:otherwise>
                 <xsl:attribute name="type">oe:DV_COUNT</xsl:attribute>
             </xsl:otherwise>
         </xsl:choose>
        
    </xsl:template>

    <!-- sb: modified and added to 29/02/08 [TMP-462] DV_ORDINAL -->
    <xsl:template match="oe:children[oe:rm_type_name='DV_ORDINAL']">
        <xsl:param name="archetypeRoot"/>

        <xsl:choose>
            <xsl:when test="oe:list/oe:value"><!-- has constrained set of ordinal values -->
            
                <xsl:element name="xs:complexType">
                    <xsl:element name="xs:sequence">
                        
                        <xsl:call-template name="generate-DV-ORDERED-elements">
                            <xsl:with-param name="rangeType">DV_ORDINAL</xsl:with-param>
                        </xsl:call-template>
                        
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">value</xsl:attribute>
                            <xsl:element name="xs:simpleType">
                                <xsl:element name="xs:restriction">
                                    <xsl:attribute name="base">xs:int</xsl:attribute>
                                    <xsl:for-each select="oe:list">
                                        
                                        <xsl:variable name="symbol-code-string"><xsl:value-of select="oe:symbol/oe:defining_code/oe:code_string"/></xsl:variable>
                                        <xsl:variable name="symbol-value"><xsl:value-of select="$archetypeRoot/oe:term_definitions[@code=$symbol-code-string]/oe:items[@id='text']"/></xsl:variable>
                                        
                                        <xsl:element name="xs:enumeration">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="oe:value"/>
                                            </xsl:attribute>
                                        </xsl:element><xsl:text disable-output-escaping="yes" xml:space="preserve">&lt;</xsl:text><xsl:value-of select="concat('!-- symbol.value = ', $symbol-value, ' (symbol.code_string = ', $symbol-code-string, ') --')"/><xsl:text disable-output-escaping="yes">&gt;
                                        </xsl:text>
                                        
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">symbol</xsl:attribute>
                            <xsl:attribute name="type">oe:DV_CODED_TEXT</xsl:attribute>
                            <xsl:attribute name="minOccurs">0</xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>

            </xsl:when>
            <xsl:otherwise>
                    <xsl:attribute name="type">oe:DV_ORDINAL</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>

    <!-- sb 04/06/08 [TMP-546] DV_INTERVAL -->
    <xsl:template match="oe:children[starts-with(oe:rm_type_name, 'DV_INTERVAL')]">
        <xsl:element name="xs:complexType">
            <xsl:element name="xs:sequence">
                    
                <xsl:element name="xs:element">
                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                    <xsl:attribute name="name">lower</xsl:attribute>
                    <xsl:choose>
                        <!-- apply lower constraints -->
                        <xsl:when test="oe:attributes[oe:rm_attribute_name='lower']/oe:children/oe:attributes">
                            <xsl:apply-templates select="oe:attributes[oe:rm_attribute_name='lower']/oe:children"/>    
                        </xsl:when>
                        <!-- no lower constraints -->
                        <xsl:otherwise>
                            <xsl:attribute name="type">
                                <xsl:text>oe:</xsl:text><xsl:value-of select="oe:attributes[oe:rm_attribute_name='lower']/oe:children/oe:rm_type_name"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element><!-- sb 07/04/09 [TMP-1020] --><xsl:text disable-output-escaping="yes">&lt;!-- lower is required if lower_unbounded is false --&gt;</xsl:text>
                <xsl:element name="xs:element">
                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                    <xsl:attribute name="name">upper</xsl:attribute>
                    <xsl:choose>
                        <!-- apply upper constraints -->
                        <xsl:when test="oe:attributes[oe:rm_attribute_name='upper']/oe:children/oe:attributes">
                            <xsl:apply-templates select="oe:attributes[oe:rm_attribute_name='upper']/oe:children"/>    
                        </xsl:when>
                        <!-- no upper constraints -->
                        <xsl:otherwise>
                            <xsl:attribute name="type">
                                <xsl:text>oe:</xsl:text><xsl:value-of select="oe:attributes[oe:rm_attribute_name='lower']/oe:children/oe:rm_type_name"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element><!-- sb 07/04/09 [TMP-1020] --><xsl:text disable-output-escaping="yes">&lt;!-- upper is required if upper_unbounded is false --&gt;</xsl:text>
                <!-- sb 07/04/09 [TMP-1020] -->
                <xsl:element name="xs:element">
                    <xsl:attribute name="name">lower_included</xsl:attribute>
                    <xsl:attribute name="type">xs:boolean</xsl:attribute>
                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                </xsl:element><xsl:text disable-output-escaping="yes">&lt;!-- lower_included is required if lower_unbounded is false  --&gt;</xsl:text>
                <xsl:element name="xs:element">
                    <xsl:attribute name="name">upper_included</xsl:attribute>
                    <xsl:attribute name="type">xs:boolean</xsl:attribute>
                    <xsl:attribute name="minOccurs">0</xsl:attribute>
                </xsl:element><xsl:text disable-output-escaping="yes">&lt;!-- upper_included is required if upper_unbounded is false  --&gt;</xsl:text>
                <xsl:element name="xs:element">
                    <xsl:attribute name="name">lower_unbounded</xsl:attribute>
                    <xsl:attribute name="type">xs:boolean</xsl:attribute>
                </xsl:element>
                <xsl:element name="xs:element">
                    <xsl:attribute name="name">upper_unbounded</xsl:attribute>
                    <xsl:attribute name="type">xs:boolean</xsl:attribute>
                </xsl:element>
                
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- sb: added 11/04/08 [TMP-502] DV_PROPORTION -->
    <xsl:template match="oe:children[oe:rm_type_name='DV_PROPORTION']">
        
        <xsl:choose>
            <xsl:when test="oe:attributes[oe:rm_attribute_name='numerator' or oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:lower
                or oe:attributes[oe:rm_attribute_name='numerator' or oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:upper">
                
                <xsl:element name="xs:complexType">
                    <xsl:element name="xs:sequence">
                        
                        <xsl:call-template name="generate-DV-QUANTIFIED-elements"/>
                        
                        <!-- apply any numerator constraints -->
                        <xsl:if test="oe:attributes[oe:rm_attribute_name='numerator']/oe:children/oe:item/oe:range/oe:lower
                            or oe:attributes[oe:rm_attribute_name='numerator']/oe:children/oe:item/oe:range/oe:upper">
                            <xsl:element name="xs:element">
                                <xsl:attribute name="name">numerator</xsl:attribute>
                                <xsl:element name="xs:simpleType">
                                    <xsl:element name="xs:restriction">
                                        <xsl:attribute name="base">xs:float</xsl:attribute>
                                        
                                        <xsl:choose>
                                            <xsl:when test="oe:attributes[oe:rm_attribute_name='numerator']/oe:children/oe:item/oe:range/oe:lower_included='true'
                                                and oe:attributes[oe:rm_attribute_name='numerator']/oe:children/oe:item/oe:range/oe:lower">
                                                <xsl:element name="xs:minInclusive">
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="oe:attributes[oe:rm_attribute_name='numerator']/oe:children/oe:item/oe:range/oe:lower"/>
                                                    </xsl:attribute>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when test="oe:attributes[oe:rm_attribute_name='numerator']/oe:children/oe:item/oe:range/oe:lower_included='false'
                                                and oe:attributes[oe:rm_attribute_name='numerator']/oe:children/oe:item/oe:range/oe:lower">
                                                <xsl:element name="xs:minExclusive">
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="oe:attributes[oe:rm_attribute_name='numerator']/oe:children/oe:item/oe:range/oe:lower"/>
                                                    </xsl:attribute>
                                                </xsl:element>
                                            </xsl:when>
                                        </xsl:choose>
                                        
                                        <xsl:choose>
                                            <xsl:when test="oe:attributes[oe:rm_attribute_name='numerator']/oe:children/oe:item/oe:range/oe:upper_included='true'
                                                and oe:attributes[oe:rm_attribute_name='numerator']/oe:children/oe:item/oe:range/oe:upper">
                                                <xsl:element name="xs:maxInclusive">
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="oe:attributes[oe:rm_attribute_name='numerator']/oe:children/oe:item/oe:range/oe:upper"/>
                                                    </xsl:attribute>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when test="oe:attributes[oe:rm_attribute_name='numerator']/oe:children/oe:item/oe:range/oe:upper_included='false'
                                                and oe:attributes[oe:rm_attribute_name='numerator']/oe:children/oe:item/oe:range/oe:upper">
                                                <xsl:element name="xs:maxExclusive">
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="oe:attributes[oe:rm_attribute_name='numerator']/oe:children/oe:item/oe:range/oe:upper"/>
                                                    </xsl:attribute>
                                                </xsl:element>
                                            </xsl:when>
                                        </xsl:choose>
                                        
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>                            
                        </xsl:if>
                        
                        <!-- apply any denominator constraints -->    
                        <xsl:if test="oe:attributes[oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:lower
                            or oe:attributes[oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:upper">
                            <xsl:element name="xs:element">
                                <xsl:attribute name="name">denominator</xsl:attribute>
                                <xsl:element name="xs:simpleType">
                                    <xsl:element name="xs:restriction">
                                        <xsl:attribute name="base">xs:float</xsl:attribute>
                                        
                                        <xsl:choose>
                                            <xsl:when test="(oe:attributes[oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:lower_included='true')
                                                and (oe:attributes[oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:lower)">
                                                <xsl:element name="xs:minInclusive">
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="oe:attributes[oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:lower"/>
                                                    </xsl:attribute>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when test="(oe:attributes[oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:lower_included='false')
                                                and (oe:attributes[oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:lower)">
                                                <xsl:element name="xs:minExclusive">
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="oe:attributes[oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:lower"/>
                                                    </xsl:attribute>
                                                </xsl:element>
                                            </xsl:when>
                                        </xsl:choose>
                                        
                                        <xsl:choose>
                                            <xsl:when test="(oe:attributes[oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:upper_included='true')
                                                and (oe:attributes[oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:upper)">
                                                <xsl:element name="xs:maxInclusive">
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="oe:attributes[oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:upper"/>
                                                    </xsl:attribute>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when test="(oe:attributes[oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:upper_included='false')
                                                and (oe:attributes[oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:upper)">
                                                <xsl:element name="xs:maxExclusive">
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="oe:attributes[oe:rm_attribute_name='denominator']/oe:children/oe:item/oe:range/oe:upper"/>
                                                    </xsl:attribute>
                                                </xsl:element>
                                            </xsl:when>
                                        </xsl:choose>
                                        
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:if>
                        
                        <!-- apply any proportion kind or type constraints -->
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">type</xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="oe:attributes[oe:rm_attribute_name='type']/oe:children/oe:item/oe:list">
                                    <xsl:element name="xs:simpleType">
                                        <xsl:element name="xs:restriction">
                                            <xsl:attribute name="base">xs:integer</xsl:attribute>
                                            <xsl:for-each select="oe:attributes[oe:rm_attribute_name='type']/oe:children/oe:item/oe:list">
                                                <xsl:element name="xs:enumeration">
                                                    <xsl:attribute name="value">
                                                        <xsl:value-of select="."/>
                                                    </xsl:attribute>
                                                </xsl:element>
                                            </xsl:for-each>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="type">oe:PROPORTION_KIND</xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                        
                    </xsl:element>
                </xsl:element>
                
            </xsl:when>
            
            <!-- DV_PROPORTION has no constraints -->
            <xsl:otherwise>
                <xsl:attribute name="type">oe:DV_PROPORTION</xsl:attribute>
            </xsl:otherwise>
            
        </xsl:choose>
            
    </xsl:template>
   
    <!-- apply C_QUANTITY_ITEM.list -->
    <xsl:template name="applyQuantityItemConstraint">
        <xsl:param name="currNode"/>
        
        <xsl:element name="xs:complexType">
            <xsl:element name="xs:sequence">
                
                <xsl:choose>
                    <!-- apply magnitude with any constraints -->
                    <xsl:when test="$currNode/oe:magnitude/oe:lower or $currNode/oe:magnitude/oe:upper">
                        
                        <xsl:call-template name="generate-DV-QUANTIFIED-elements"/>
                        
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">magnitude</xsl:attribute>
                            <xsl:element name="xs:simpleType">
                                <xsl:element name="xs:restriction">
                                    <xsl:attribute name="base">xs:double</xsl:attribute>
                                    
                                    <!-- apply any precision constraints (only if it is >=0 because '-1' means no constraint anyway) -->
                                    <!-- n.b. DV_QUANTITY.precision is a single integer and is represented as a lower and upper (interval integer)
                                            values in the AOM or OPT with lower_included and upper_included BOTH set to true, so we can just take
                                            *either* the lower/upper value if it exists in the OPT (doesn't matter, they're both the same) -->
                                    <xsl:if test="(string-length($currNode/oe:precision/oe:lower)>0) and (not($currNode/oe:precision/oe:lower = '-1'))">
                                        <!-- e.g. for precision of 2: <xs:pattern value="(\+|\-)?(0|[1-9][0-9]*)?(\.[0-9]{2})?"/> -->
                                        <xsl:choose>
                                            <xsl:when test="(number($currNode/oe:precision/oe:lower))>0">
                                                <!-- e.g. for precision of 2: <xs:pattern value="(\+|\-)?(0|[1-9][0-9]*)?(\.[0-9]{2})?"/> -->
                                                <xsl:element name="xs:pattern">
                                                    <xsl:attribute name="value"><xsl:value-of select="$begin-double-base-pattern"/><xsl:value-of select="$currNode/oe:precision/oe:lower"/><xsl:value-of select="$end-double-base-pattern"/></xsl:attribute>
                                                </xsl:element>
                                            </xsl:when>
                                            <!-- is constrained to be integral -->
                                            <xsl:when test="(number($currNode/oe:precision/oe:lower))=0">
                                                <xsl:element name="xs:pattern">
                                                    <xsl:attribute name="value"><xsl:value-of select="$integral-pattern"/></xsl:attribute>
                                                </xsl:element>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:if>
                                    
                                    <!-- apply lower magnitude constraint -->
                                    <xsl:choose>
                                        <xsl:when test="$currNode/oe:magnitude[oe:lower_included='true'] and $currNode/oe:magnitude/oe:lower">
                                            <xsl:element name="xs:minInclusive">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$currNode/oe:magnitude/oe:lower"/>
                                                </xsl:attribute>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:when test="$currNode/oe:magnitude[oe:lower_included='false'] and $currNode/oe:magnitude/oe:lower">
                                            <xsl:element name="xs:minExclusive">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$currNode/oe:magnitude/oe:lower"/>
                                                </xsl:attribute>
                                            </xsl:element>
                                        </xsl:when>
                                    </xsl:choose>
                                    
                                    <!-- apply upper magnitude constraint -->
                                    <xsl:choose>
                                        <xsl:when test="$currNode/oe:magnitude[oe:upper_included='true'] and $currNode/oe:magnitude/oe:upper">
                                            <xsl:element name="xs:maxInclusive">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$currNode/oe:magnitude/oe:upper"/>
                                                </xsl:attribute>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:when test="$currNode/oe:magnitude[oe:upper_included='false'] and $currNode/oe:magnitude/oe:upper">
                                            <xsl:element name="xs:maxExclusive">
                                                <xsl:attribute name="value">
                                                    <xsl:value-of select="$currNode/oe:magnitude/oe:upper"/>
                                                </xsl:attribute>
                                            </xsl:element>
                                        </xsl:when>
                                    </xsl:choose>
                                    
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>                            
                        
                    </xsl:when>
                    <!-- magnitude with no constraints -->
                    <xsl:otherwise>
                        
                        <xsl:call-template name="generate-DV-QUANTIFIED-elements"/>
                        
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">magnitude</xsl:attribute>
                            
                            <xsl:choose>
                                <xsl:when test="(string-length($currNode/oe:precision/oe:lower)>0) and (not($currNode/oe:precision/oe:lower = '-1'))">
                                    <xsl:element name="xs:simpleType">
                                        <xsl:element name="xs:restriction">
                                            <xsl:attribute name="base">xs:double</xsl:attribute>
                                            
                                            <xsl:choose>
                                                <xsl:when test="(number($currNode/oe:precision/oe:lower))>0">
                                                    <!-- apply any precision constraints (only if it is >=0 because '-1' means no constraint anyway) -->
                                                    <!-- n.b. DV_QUANTITY.precision is a single integer and is represented as a lower and upper (interval integer)
                                                        values in the AOM or OPT with lower_included and upper_included BOTH set to true, so we can just take
                                                        *either* the lower/upper value if it exists in the OPT (doesn't matter, they're both the same) -->
                                                    <!-- e.g. for precision of 2: <xs:pattern value="(\+|\-)?(0|[1-9][0-9]*)?(\.[0-9]{2})?"/> -->
                                                    <xsl:element name="xs:pattern">
                                                        <xsl:attribute name="value"><xsl:value-of select="$begin-double-base-pattern"/><xsl:value-of select="$currNode/oe:precision/oe:lower"/><xsl:value-of select="$end-double-base-pattern"/></xsl:attribute>
                                                    </xsl:element>
                                                </xsl:when>
                                                <!-- is integral/whole only -->
                                                <xsl:when test="(number($currNode/oe:precision/oe:lower))=0">
                                                    <xsl:element name="xs:pattern">
                                                        <xsl:attribute name="value"><xsl:value-of select="$integral-pattern"/></xsl:attribute>
                                                    </xsl:element>
                                                </xsl:when>
                                            </xsl:choose>
                                            
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="type">xs:double</xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>

                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
                
                <!-- apply any precision constraints -->    
                <xsl:if test="$currNode/oe:precision/oe:lower or $currNode/oe:precision/oe:upper">
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">precision</xsl:attribute>
                        <xsl:element name="xs:simpleType">
                            <xsl:element name="xs:restriction">
                                <xsl:attribute name="base">xs:int</xsl:attribute>
                                
                                <!-- apply lower precision constraint -->
                                <xsl:choose>
                                    <xsl:when test="$currNode/oe:precision[oe:lower_included='true'] and $currNode/oe:precision/oe:lower">
                                        <xsl:element name="xs:minInclusive">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$currNode/oe:precision/oe:lower"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="$currNode/oe:precision[oe:lower_included='false'] and $currNode/oe:precision/oe:lower">
                                        <xsl:element name="xs:minExclusive">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$currNode/oe:precision/oe:lower"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:when>
                                </xsl:choose>
                                
                                <!-- apply upper precision constraint -->
                                <xsl:choose>
                                    <xsl:when test="$currNode/oe:precision[oe:upper_included='true'] and $currNode/oe:precision/oe:upper">
                                        <xsl:element name="xs:maxInclusive">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$currNode/oe:precision/oe:upper"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="$currNode/oe:precision[oe:upper_included='false'] and $currNode/oe:precision/oe:upper">
                                        <xsl:element name="xs:maxExclusive">
                                            <xsl:attribute name="value">
                                                <xsl:value-of select="$currNode/oe:precision/oe:upper"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:when>
                                </xsl:choose>
                                
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                
                <xsl:choose>
                    <!-- apply any unit constraints -->
                    <xsl:when test="$currNode/oe:units">
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">units</xsl:attribute>
                            <xsl:attribute name="type">xs:string</xsl:attribute>
                            <!-- 29/07/08 added in case units is empty string then there should not be any constraint -->
                            <xsl:if test="string-length($currNode/oe:units)>0">
                                <xsl:attribute name="fixed"><xsl:value-of select="$currNode/oe:units"/></xsl:attribute>
                            </xsl:if>
                        </xsl:element>
                    </xsl:when>
                    <!-- unit with no constraints -->
                    <xsl:otherwise>
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">units</xsl:attribute>
                            <xsl:attribute name="type">xs:string</xsl:attribute>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
                
                <!-- TO DO: Implement any constraints on 'normal_range' values -->
                
            </xsl:element>
        </xsl:element>
        
    </xsl:template>

    <!-- apply DV_QUANTITY with NO C_QUANTITY_ITEM -->
    <xsl:template match="oe:children[oe:rm_type_name='DV_QUANTITY']">
        
        <xsl:choose>
            
            <!-- apply any quantity constraint (multiple C_QUANTITY_ITEMs
            are handled in the ELEMENT template NOT here!) -->
            <xsl:when test="oe:list">
                
                <!-- This should only iterate once because assumes a single 'list'
                attribute of type C_QUANTITY_ITEM. -->
                <xsl:for-each select="oe:list">
                
                    <xsl:element name="xs:complexType">
                        <xsl:element name="xs:sequence">
                            
                            <xsl:choose>
                                <!-- apply any magnitude constraints -->
                                <xsl:when test="oe:magnitude/oe:lower or oe:magnitude/oe:upper">
                                     
                                    <xsl:call-template name="generate-DV-QUANTIFIED-elements"/>
                                     
                                    <xsl:element name="xs:element">
                                        <xsl:attribute name="name">magnitude</xsl:attribute>
                                        <xsl:element name="xs:simpleType">
                                            <xsl:element name="xs:restriction">
                                                <xsl:attribute name="base">xs:double</xsl:attribute>
                                                
                                                <!-- apply any precision constraints (only if it is >=0 because '-1' means no constraint anyway) -->
                                                <!-- n.b. DV_QUANTITY.precision is a single integer and is represented as a lower and upper (interval integer)
                                                    values in the AOM or OPT with lower_included and upper_included BOTH set to true, so we can just take
                                                    *either* the lower/upper value if it exists in the OPT (doesn't matter, they're both the same) -->
                                                <xsl:if test="(string-length(oe:precision/oe:lower)>0) and (not(oe:precision/oe:lower = '-1'))">
                                                    <xsl:choose>
                                                        <xsl:when test="(number(oe:precision/oe:lower))>0">
                                                            <!-- e.g. for precision of 2: <xs:pattern value="(\+|\-)?(0|[1-9][0-9]*)?(\.[0-9]{2})?"/> -->
                                                            <xsl:element name="xs:pattern">
                                                                <xsl:attribute name="value"><xsl:value-of select="$begin-double-base-pattern"/><xsl:value-of select="oe:precision/oe:lower"/><xsl:value-of select="$end-double-base-pattern"/></xsl:attribute>
                                                            </xsl:element>
                                                        </xsl:when>
                                                        <!-- is integral/whole only -->
                                                        <xsl:when test="(number(oe:precision/oe:lower))=0">
                                                            <xsl:element name="xs:pattern">
                                                                <xsl:attribute name="value"><xsl:value-of select="$integral-pattern"/></xsl:attribute>
                                                            </xsl:element>
                                                        </xsl:when>
                                                    </xsl:choose>
                                                </xsl:if>
                                                
                                                <!-- apply lower magnitude constraint -->
                                                <xsl:choose>
                                                    <xsl:when test="oe:magnitude[oe:lower_included='true'] and oe:magnitude/oe:lower">
                                                        <xsl:element name="xs:minInclusive">
                                                            <xsl:attribute name="value">
                                                                <xsl:value-of select="oe:magnitude/oe:lower"/>
                                                            </xsl:attribute>
                                                        </xsl:element>
                                                    </xsl:when>
                                                    <xsl:when test="oe:magnitude[oe:lower_included='false'] and oe:magnitude/oe:lower">
                                                        <xsl:element name="xs:minExclusive">
                                                            <xsl:attribute name="value">
                                                                <xsl:value-of select="oe:magnitude/oe:lower"/>
                                                            </xsl:attribute>
                                                        </xsl:element>
                                                    </xsl:when>
                                                </xsl:choose>
                                                
                                                <!-- apply upper magnitude constraint -->
                                                <xsl:choose>
                                                    <xsl:when test="oe:magnitude[oe:upper_included='true'] and oe:magnitude/oe:upper">
                                                        <xsl:element name="xs:maxInclusive">
                                                            <xsl:attribute name="value">
                                                                <xsl:value-of select="oe:magnitude/oe:upper"/>
                                                            </xsl:attribute>
                                                        </xsl:element>
                                                    </xsl:when>
                                                    <xsl:when test="oe:magnitude[oe:upper_included='false'] and oe:magnitude/oe:upper">
                                                        <xsl:element name="xs:maxExclusive">
                                                            <xsl:attribute name="value">
                                                                <xsl:value-of select="oe:magnitude/oe:upper"/>
                                                            </xsl:attribute>
                                                        </xsl:element>
                                                    </xsl:when>
                                                </xsl:choose>
                                                
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:element>                            
                                    
                                </xsl:when>
                                <!-- magnitude with no constraints -->
                                <xsl:otherwise>
                                    
                                    <xsl:call-template name="generate-DV-QUANTIFIED-elements"/>
                                    
                                    <xsl:element name="xs:element">
                                        <xsl:attribute name="name">magnitude</xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when test="(number(oe:precision/oe:lower))>0">
                                                <xsl:element name="xs:simpleType">
                                                    <xsl:element name="xs:restriction">
                                                        <xsl:attribute name="base">xs:double</xsl:attribute>
                                                        <!-- apply any precision constraints (only if it is >0 ; '-1' means no constraint) -->
                                                        <!-- n.b. DV_QUANTITY.precision is a single integer and is represented as a lower and upper (interval integer)
                                                            values in the AOM or OPT with lower_included and upper_included BOTH set to true, so we can just take
                                                            *either* the lower/upper value if it exists in the OPT (doesn't matter, they're both the same) -->
                                                        <!-- e.g. for precision of 2: <xs:pattern value="(\+|\-)?(0|[1-9][0-9]*)?(\.[0-9]{2})?"/> -->
                                                        <xsl:element name="xs:pattern">
                                                            <xsl:attribute name="value"><xsl:value-of select="$begin-double-base-pattern"/><xsl:value-of select="oe:precision/oe:lower"/><xsl:value-of select="$end-double-base-pattern"/></xsl:attribute>
                                                        </xsl:element>
                                                    </xsl:element>
                                                </xsl:element>
                                            </xsl:when>
                                            <!-- is constrained to be integral -->
                                            <xsl:when test="(number(oe:precision/oe:lower))=0">
                                                <xsl:element name="xs:simpleType">
                                                    <xsl:element name="xs:restriction">
                                                        <xsl:attribute name="base">xs:double</xsl:attribute>
                                                        <!-- apply any precision constraints to be integral/whole only -->
                                                        <!-- n.b. DV_QUANTITY.precision is a single integer and is represented as a lower and upper (interval integer)
                                                            values in the AOM or OPT with lower_included and upper_included BOTH set to true, so we can just take
                                                            *either* the lower/upper value if it exists in the OPT (doesn't matter, they're both the same) -->
                                                        <xsl:element name="xs:pattern">
                                                            <xsl:attribute name="value"><xsl:value-of select="$integral-pattern"/></xsl:attribute>
                                                        </xsl:element>
                                                    </xsl:element>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:attribute name="type">xs:double</xsl:attribute>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>

                            <!-- apply any precision constraints -->    
                            <xsl:if test="oe:precision/oe:lower or oe:precision/oe:upper">
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">precision</xsl:attribute>
                                    <xsl:element name="xs:simpleType">
                                        <xsl:element name="xs:restriction">
                                            <xsl:attribute name="base">xs:int</xsl:attribute>
                                            
                                            <!-- apply lower precision constraint -->
                                            <xsl:choose>
                                                <xsl:when test="oe:precision[oe:lower_included='true'] and oe:precision/oe:lower">
                                                    <xsl:element name="xs:minInclusive">
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="oe:precision/oe:lower"/>
                                                        </xsl:attribute>
                                                    </xsl:element>
                                                </xsl:when>
                                                <xsl:when test="oe:precision[oe:lower_included='false'] and oe:precision/oe:lower">
                                                    <xsl:element name="xs:minExclusive">
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="oe:precision/oe:lower"/>
                                                        </xsl:attribute>
                                                    </xsl:element>
                                                </xsl:when>
                                            </xsl:choose>
                                            
                                            <!-- apply upper precision constraint -->
                                            <xsl:choose>
                                                <xsl:when test="oe:precision[oe:upper_included='true'] and oe:precision/oe:upper">
                                                    <xsl:element name="xs:maxInclusive">
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="oe:precision/oe:upper"/>
                                                        </xsl:attribute>
                                                    </xsl:element>
                                                </xsl:when>
                                                <xsl:when test="oe:precision[oe:upper_included='false'] and oe:precision/oe:upper">
                                                    <xsl:element name="xs:maxExclusive">
                                                        <xsl:attribute name="value">
                                                            <xsl:value-of select="oe:precision/oe:upper"/>
                                                        </xsl:attribute>
                                                    </xsl:element>
                                                </xsl:when>
                                            </xsl:choose>
                                            
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>
                            
                            <xsl:choose>
                                <!-- apply unit with constraints -->
                                <xsl:when test="oe:units">
                                    <xsl:element name="xs:element">
                                        <xsl:attribute name="name">units</xsl:attribute>
                                        <xsl:attribute name="type">xs:string</xsl:attribute>
                                        <!-- 29/07/08 added in case units is empty string then there should not be any constraint -->
                                        <xsl:if test="string-length(oe:units)>0">
                                            <xsl:attribute name="fixed"><xsl:value-of select="oe:units"/></xsl:attribute>
                                        </xsl:if>
                                    </xsl:element>
                                </xsl:when>
                                <!-- unit with no constraints -->
                                <xsl:otherwise>
                                    <xsl:element name="xs:element">
                                        <xsl:attribute name="name">units</xsl:attribute>
                                        <xsl:attribute name="type">xs:string</xsl:attribute>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                            <!-- TO DO: Implement any constraints on 'normal_range' values -->
                            
                        </xsl:element>
                    </xsl:element>
                    
                </xsl:for-each>
            
            </xsl:when>
            
            <!-- no quantity constraints -->
            <xsl:otherwise>
                <xsl:attribute name="type">oe:DV_QUANTITY</xsl:attribute>
            </xsl:otherwise>
        
        </xsl:choose>
        
    </xsl:template>

    <!-- [TMP-586] TOTEST -->
    <xsl:template match="oe:children[oe:rm_type_name='DV_DATE_TIME']">
            
        <xsl:choose>
            <!-- apply date time constraints-->
            <xsl:when test="oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:item/oe:pattern">
                <xsl:element name="xs:complexType">
                    <xsl:element name="xs:sequence">
                        
                        <xsl:call-template name="generate-DV-QUANTIFIED-elements"/>
                        
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">value</xsl:attribute>
                            <xsl:attribute name="type">oe:Iso8601DateTime</xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <!-- no date time constraints -->
            <xsl:otherwise>
                <xsl:attribute name="type">oe:DV_DATE_TIME</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
            
    </xsl:template>
    
    <!-- [TMP-586] TOTEST -->
    <xsl:template match="oe:children[oe:rm_type_name='DV_DATE']">
                    
        <xsl:choose>
            <!-- apply date constraints-->
            <xsl:when test="oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:item/oe:pattern">
                <xsl:element name="xs:complexType">
                    <xsl:element name="xs:sequence">
                        
                        <xsl:call-template name="generate-DV-QUANTIFIED-elements"/>
                        
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">value</xsl:attribute>
                            <xsl:attribute name="type">oe:Iso8601Date</xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <!-- no date time constraints -->
            <xsl:otherwise>
                <xsl:attribute name="type">oe:DV_DATE</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
            
    </xsl:template>
    
    <!-- [TMP-586] TOTEST -->
    <xsl:template match="oe:children[oe:rm_type_name='DV_TIME']">
            
        <xsl:choose>
            <!-- apply time constraints-->
            <xsl:when test="oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:item/oe:pattern">
                <xsl:element name="xs:complexType">
                    <xsl:element name="xs:sequence">
                        
                        <xsl:call-template name="generate-DV-QUANTIFIED-elements"/>
                        
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">value</xsl:attribute>
                            <xsl:attribute name="type">oe:Iso8601Time</xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <!-- no date time constraints -->
            <xsl:otherwise>
                <xsl:attribute name="type">oe:DV_TIME</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
            
    </xsl:template>
    
    <!-- [TMP-586] -->
    <xsl:template match="oe:children[oe:rm_type_name='DV_BOOLEAN']">

        <xsl:attribute name="type">oe:DV_BOOLEAN</xsl:attribute>
            
    </xsl:template>
    
    <!-- [TMP-586] TOTEST -->
    <xsl:template match="oe:children[oe:rm_type_name='DV_IDENTIFIER']">
    
        <xsl:choose>
            <!-- has DV_IDENTIFIER constraints -->
            <xsl:when test="oe:attributes[oe:rm_attribute_name='value']/oe:children">
                <!-- issuer -->
                <xsl:if test="oe:attributes[oe:rm_attribute_name='issuer']/oe:children/oe:item[@xsi:type='C_STRING']">
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">issuer</xsl:attribute>
                        <xsl:call-template name="applyStringConstraint">
                            <xsl:with-param name="currNode" select="oe:attributes[oe:rm_attribute_name='issuer']"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:if>
                <!-- assigner -->
                <xsl:if test="oe:attributes[oe:rm_attribute_name='assigner']/oe:children/oe:item[@xsi:type='C_STRING']">
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">assigner</xsl:attribute>
                        <xsl:call-template name="applyStringConstraint">
                            <xsl:with-param name="currNode" select="oe:attributes[oe:rm_attribute_name='assigner']"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:if>
                <!-- id -->
                <xsl:if test="oe:attributes[oe:rm_attribute_name='id']/oe:children/oe:item[@xsi:type='C_STRING']">
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">id</xsl:attribute>
                        <xsl:call-template name="applyStringConstraint">
                            <xsl:with-param name="currNode" select="oe:attributes[oe:rm_attribute_name='id']"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:if>
                <!-- type -->
                <xsl:if test="oe:attributes[oe:rm_attribute_name='type']/oe:children/oe:item[@xsi:type='C_STRING']">
                    <xsl:element name="xs:element">
                        <xsl:attribute name="name">type</xsl:attribute>
                        <xsl:call-template name="applyStringConstraint">
                            <xsl:with-param name="currNode" select="oe:attributes[oe:rm_attribute_name='type']"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <!-- no identifier constraints -->
                <xsl:attribute name="type">oe:DV_IDENTIFIER</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="applyStringConstraint">
        <xsl:param name="currNode"/>
                
        <xsl:choose>
            <!-- C_STRING may have either pattern or list constraint -->
            <xsl:when test="$currNode/oe:pattern">
                <xsl:element name="xs:simpleType">
                    <xsl:element name="xs:restriction">
                        <xsl:attribute name="base">xs:string</xsl:attribute>
                        <xsl:element name="xs:pattern">
                            <xsl:attribute name="value">
                                <xsl:value-of select="$currNode/oe:pattern"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$currNode/oe:list">
                <xsl:for-each select="$currNode/oe:list">
                    <xsl:element name="xs:simpleType">
                        <xsl:element name="xs:restriction">
                            <xsl:attribute name="base">xs:string</xsl:attribute>
                            <xsl:element name="xs:enumeration">
                                <xsl:attribute name="value">
                                    <xsl:value-of select="."/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
       
    </xsl:template>
    
    <!-- [TMP-586] TODO -->
    <xsl:template match="oe:children[oe:rm_type_name='DV_URI']">
       
       <!--<xsl:choose>
           <xsl:when test="">
               <xsl:call-template name="applyStringConstraint">
                   <xsl:with-param name="currNode" select="oe:attributes[oe:rm_attribute_name=]"/>
               </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>-->
        <!-- no DV_URI constraints -->
        <xsl:attribute name="type">oe:DV_URI</xsl:attribute>
        <!--</xsl:otherwise>
       </xsl:choose>-->
         
    </xsl:template>
    
    <!-- [TMP-586] TODO -->
    <xsl:template match="oe:children[oe:rm_type_name='DV_EHR_URI']">
        
        <!--<xsl:choose>
            <xsl:when test="">
            <xsl:call-template name="applyStringConstraint">
            <xsl:with-param name="currNode" select="oe:attributes[oe:rm_attribute_name=]"/>
            </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>-->
        <!-- no DV_EHR_URI constraints -->
        <xsl:attribute name="type">oe:DV_EHR_URI</xsl:attribute>
        <!--</xsl:otherwise>
            </xsl:choose>-->
        
    </xsl:template>
    
    <!-- [TMP-586] TODO -->
    <xsl:template match="oe:children[oe:rm_type_name='DV_PARSABLE']">
        
        <!--<xsl:choose>
            <xsl:when test="">
            <xsl:call-template name="applyStringConstraint">
            <xsl:with-param name="currNode" select="oe:attributes[oe:rm_attribute_name='value']"/>
            </xsl:call-template>
            <xsl:call-template name="applyStringConstraint">
            <xsl:with-param name="currNode" select="oe:attributes[oe:rm_attribute_name='formalism']"/>
            </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>-->
        <!-- no DV_PARSABLE constraints -->
        <xsl:attribute name="type">oe:DV_PARSABLE</xsl:attribute>
        <!--</xsl:otherwise>
            </xsl:choose>-->
        
    </xsl:template>
    
    <!-- [TMP-586] -->
    <xsl:template match="oe:children[oe:rm_type_name='DV_MULTIMEDIA']">
        <xsl:choose>
        	<xsl:when test="oe:attributes[oe:rm_attribute_name='media_type']/oe:children/oe:code_list"><!-- apply media type constraints as CODE_PHRASE-->
        		<xsl:element name="xs:complexType">
        			<xsl:element name="xs:sequence">
        				
        				<xsl:element name="xs:element">
        					<xsl:attribute name="name">alternate_text</xsl:attribute>
        					<xsl:attribute name="type">xs:string</xsl:attribute>
        					<xsl:attribute name="minOccurs">0</xsl:attribute>
        				</xsl:element>
        				<xsl:element name="xs:element">
        					<xsl:attribute name="name">uri</xsl:attribute>
        					<xsl:attribute name="type">oe:DV_URI</xsl:attribute>
        					<xsl:attribute name="minOccurs">0</xsl:attribute>
        				</xsl:element>
        				<xsl:element name="xs:element">
        					<xsl:attribute name="name">data</xsl:attribute>
        					<xsl:attribute name="type">xs:base64Binary</xsl:attribute>
        					<xsl:attribute name="minOccurs">0</xsl:attribute>
        				</xsl:element>
        				
        				<xsl:element name="xs:element">
        					<xsl:attribute name="name">media_type</xsl:attribute>
        					<xsl:element name="xs:complexType">
        						<xsl:element name="xs:sequence">
        							<xsl:element name="xs:element">
        								<xsl:attribute name="name">terminology_id</xsl:attribute>
        								<xsl:element name="xs:complexType">
        									<xsl:element name="xs:sequence">
        										<xsl:element name="xs:element">
        											<xsl:attribute name="name">value</xsl:attribute>
        											<xsl:attribute name="type">xs:token</xsl:attribute>
        											<xsl:attribute name="fixed">openehr</xsl:attribute>
        										</xsl:element>
        									</xsl:element>
        								</xsl:element>
        							</xsl:element>
        							<xsl:element name="xs:element">
        								<xsl:attribute name="name">code_string</xsl:attribute>
        								<xsl:choose>
        									<xsl:when test="count(oe:attributes[oe:rm_attribute_name='media_type']/oe:children/oe:code_list)>1">
        										<xsl:element name="xs:simpleType">
        											<xsl:element name="xs:restriction">
        												<xsl:attribute name="base">xs:string</xsl:attribute>
        												<xsl:for-each select="oe:attributes[oe:rm_attribute_name='media_type']/oe:children/oe:code_list">
        													<xsl:element name="xs:enumeration"><xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute></xsl:element>
        												</xsl:for-each>
        											</xsl:element>
        										</xsl:element>
        									</xsl:when>
        									<xsl:when test="count(oe:attributes[oe:rm_attribute_name='media_type']/oe:children/oe:code_list)=1">
        										<xsl:attribute name="fixed"><xsl:value-of select="oe:attributes[oe:rm_attribute_name='media_type']/oe:children/oe:code_list"/></xsl:attribute>
        										<xsl:attribute name="type">xs:string</xsl:attribute>
        									</xsl:when>
        								</xsl:choose>
        							</xsl:element>
        						</xsl:element>
        					</xsl:element>
        				</xsl:element>
        				
        				<xsl:element name="xs:element">
        					<xsl:attribute name="name">size</xsl:attribute>
        					<xsl:attribute name="type">xs:int</xsl:attribute>
        				</xsl:element>
        			
        			</xsl:element>
        		</xsl:element>
        	</xsl:when>
        	
        	<xsl:otherwise><!-- no media type constraints -->
        		<xsl:attribute name="type">oe:DV_MULTIMEDIA</xsl:attribute>
        	</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- [TMP-586] -->
    <xsl:template match="oe:children[oe:rm_type_name='DV_DURATION']">
        
        <xsl:choose>
            <xsl:when test="oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:item/oe:pattern">
                        
                <xsl:element name="xs:complexType">
                    <xsl:element name="xs:sequence">
                        
                        <xsl:call-template name="generate-DV-QUANTIFIED-elements"/>
                        
                        <xsl:element name="xs:element">
                            
                            <xsl:attribute name="name">value</xsl:attribute>
                            
                            <xsl:variable name="lower-case-iso-duration-chars">pymwdths</xsl:variable>
                            <xsl:variable name="upper-case-iso-duration-chars">PYMWDTHS</xsl:variable>
                            
                            <!-- translate to UPPER case -->
                            <xsl:variable name="pattern"><xsl:value-of select="translate(oe:attributes[oe:rm_attribute_name='value']/oe:children/oe:item/oe:pattern, $lower-case-iso-duration-chars, $upper-case-iso-duration-chars)"/></xsl:variable>
                            
                            
                            <xsl:element name="xs:simpleType">
                                <xsl:element name="xs:restriction">
                                    <xsl:attribute name="base">xs:string</xsl:attribute>
                                    <xsl:element name="xs:pattern">
                                        
                                        <xsl:attribute name="value">
                                            
                                            <xsl:choose>
                                                
                                                <!-- allow all time units -->
                                                <xsl:when test="$pattern='PYMWDTHMS'">
                                                    <xsl:text>P(\d+Y)?(\d+M)?(\d+W)?(\d+D)?(T(\d+H)?(\d+M)?(\d+(\.\d+)?S)?)?</xsl:text>
                                                </xsl:when>
                                                
                                                <!-- constrained set of units -->
                                                <xsl:otherwise>
                                                    <xsl:text>P</xsl:text>
                                                    <xsl:call-template name="construct-duration-regex-pattern">
                                                        <xsl:with-param name="pattern">
                                                            <!-- translate to UPPER case -->
                                                            <xsl:value-of select="translate(substring-after($pattern, 'P'), $lower-case-iso-duration-chars, $upper-case-iso-duration-chars)"/>
                                                        </xsl:with-param>
                                                    </xsl:call-template>
                                                </xsl:otherwise>
                                                
                                            </xsl:choose>
                                            
                                        </xsl:attribute>
                                        
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                            
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                    
            </xsl:when>

            <xsl:otherwise>
                <xsl:attribute name="type">oe:DV_DURATION</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <!-- 21/08/08: added optional DV_QUANTIFIED.magnitude_status (call this template for all DV_QUANTIFIED datatypes that have constraints on their 'value',
            otherwise it will be inherited from the RM data type schema type by default (e.g. [unconstrained] "oe:DV_QUANTITY" will inherit this so don't need in TDS) -->
    <!--<xsl:template name="optional-magnitude-status">-->
    <xsl:template name="generate-DV-QUANTIFIED-elements">
        <xsl:param name="rangeType"/>
        <xsl:param name="rangeUnits"/>
        
        <xsl:call-template name="generate-DV-ORDERED-elements"><!-- inherits DV_ORDERED elements -->
            <xsl:with-param name="rangeType" select="$rangeType"/><!-- FUTURE (sam's request for the type and units of ranges to be the same as the element value) -->
            <xsl:with-param name="rangeUnits" select="$rangeUnits"/><!-- FUTURE (sam's request for the type and units of ranges to be the same as the element value) -->
        </xsl:call-template>
        <xsl:element name="xs:element">
            <xsl:attribute name="name">magnitude_status</xsl:attribute>
            <xsl:attribute name="type">xs:string</xsl:attribute>
            <xsl:attribute name="minOccurs">0</xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="generate-DV-ORDERED-elements">
        <xsl:param name="rangeType"/>
        <xsl:param name="rangeUnits"/>
        
        <xsl:element name="xs:element">
            <xsl:attribute name="name">normal_range</xsl:attribute>
            <xsl:attribute name="type">oe:DV_INTERVAL</xsl:attribute>
            <xsl:attribute name="minOccurs">0</xsl:attribute>
        </xsl:element>
        <xsl:element name="xs:element">
            <xsl:attribute name="name">other_reference_ranges</xsl:attribute>
            <xsl:attribute name="type">oe:REFERENCE_RANGE</xsl:attribute>
            <xsl:attribute name="minOccurs">0</xsl:attribute>
            <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
        </xsl:element>
        <xsl:element name="xs:element">
            <xsl:attribute name="name">normal_status</xsl:attribute>
            <xsl:attribute name="type">oe:CODE_PHRASE</xsl:attribute>
            <xsl:attribute name="minOccurs">0</xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <!-- [TMP-586] -->
    <xsl:template name="constructParticipations">
        <xsl:param name="currNode"/>
        
<!--        <xsl:variable name="otherParticipationNode" select="$currNode/oe:attributes[oe:rm_attribute_name='other_participations']"/>-->
            
<!--                <xsl:choose>-->
                    <!-- there are multiple PARTICIPATION constraints -->
                    <!--<xsl:when test="count($otherParticipationNode/oe:children[oe:rm_type_name='PARTICIPATION'])>0">
                        
                            <xsl:for-each select="$otherParticipationNode/oe:children[oe:rm_type_name='PARTICIPATION']">
                                
                                <xsl:element name="xs:element">
                                    <xsl:attribute name="name">other_participations</xsl:attribute>
                                
                                <xsl:attribute name="minOccurs">
                                    <xsl:value-of select="oe:occurrences/oe:lower"/>
                                </xsl:attribute>
                                <xsl:attribute name="maxOccurs">
                                    <xsl:choose>
                                        <xsl:when test="oe:occurrences/oe:upper">
                                            <xsl:value-of select="oe:occurrences/oe:upper"/>
                                        </xsl:when>
                                        <xsl:otherwise>unbounded</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                
                                <xsl:element name="xs:complexType">
                                    <xsl:element name="xs:sequence">-->
                                        <!-- function (mandatory) -->
                                        <!--<xsl:element name="xs:element">
                                            <xsl:attribute name="name">function</xsl:attribute>
                                            <xsl:call-template name="constructTextAndCodedTextRMAttribute">
                                                <xsl:with-param name="rm-attribute-children-context" select="oe:attributes[oe:rm_attribute_name='function']/oe:children"/>
                                            </xsl:call-template>
                                        </xsl:element>-->
                                        <!-- time (optional) -->
                                        <!--<xsl:if test="oe:attributes[oe:rm_attribute_name='time']">
                                            <xsl:element name="xs:element">
                                                <xsl:attribute name="name">time</xsl:attribute>
                                                <xsl:attribute name="minOccurs">
                                                    <xsl:value-of select="oe:attributes[oe:rm_attribute_name='time']/oe:existence/oe:lower"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="maxOccurs">
                                                    <xsl:value-of select="oe:attributes[oe:rm_attribute_name='time']/oe:existence/oe:upper"/>
                                                </xsl:attribute>-->
                                                <!-- oe:DV_INTERVAL&lt;DV_DATE_TIME&gt; is not valid as xml attribute value due to the angle brackets, so
                                                    implement as DV_INTERVAL with constraints on lower and upper concrete datatype of DV_DATE_TIME -->
                                                <!--<xsl:element name="xs:complexType">
                                                    <xsl:element name="xs:sequence">
                                                        <xsl:element name="xs:element">
                                                            <xsl:attribute name="name">lower</xsl:attribute>
                                                            <xsl:attribute name="type">oe:DV_DATE_TIME</xsl:attribute>
                                                            <xsl:attribute name="minOccurs">0</xsl:attribute>
                                                        </xsl:element>
                                                        <xsl:element name="xs:element">
                                                            <xsl:attribute name="name">upper</xsl:attribute>
                                                            <xsl:attribute name="type">oe:DV_DATE_TIME</xsl:attribute>
                                                            <xsl:attribute name="minOccurs">0</xsl:attribute>
                                                        </xsl:element>
                                                        <xsl:element name="xs:element">
                                                            <xsl:attribute name="name">lower_included</xsl:attribute>
                                                            <xsl:attribute name="type">xs:boolean</xsl:attribute>
                                                            <xsl:attribute name="minOccurs">0</xsl:attribute>
                                                        </xsl:element>
                                                        <xsl:element name="xs:element">
                                                            <xsl:attribute name="name">upper_included</xsl:attribute>
                                                            <xsl:attribute name="type">xs:boolean</xsl:attribute>
                                                            <xsl:attribute name="minOccurs">0</xsl:attribute>
                                                        </xsl:element>
                                                        <xsl:element name="xs:element">
                                                            <xsl:attribute name="name">lower_unbounded</xsl:attribute>
                                                            <xsl:attribute name="type">xs:boolean</xsl:attribute>
                                                        </xsl:element>
                                                        <xsl:element name="xs:element">
                                                            <xsl:attribute name="name">upper_unbounded</xsl:attribute>
                                                            <xsl:attribute name="type">xs:boolean</xsl:attribute>
                                                        </xsl:element>
                                                    </xsl:element>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:if>-->
                                        <!-- mode (mandatory) -->
                                        <!--<xsl:element name="xs:element">
                                            <xsl:attribute name="name">mode</xsl:attribute>
                                            <xsl:call-template name="constructTextAndCodedTextRMAttribute">
                                                <xsl:with-param name="rm-attribute-children-context" select="oe:attributes[oe:rm_attribute_name='mode']/oe:children"/>
                                            </xsl:call-template>
                                        </xsl:element>-->
                                        <!-- performer (mandatory) - currently not constrainable in archetype, but must be available at run-time -->
                                        <!--<xsl:element name="xs:element">
                                            <xsl:attribute name="name">performer</xsl:attribute>
                                            <xsl:attribute name="type">oe:PARTY_PROXY</xsl:attribute>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            
                                </xsl:element>
                            
                            </xsl:for-each>
                        
                        </xsl:when>-->
                    <!-- no constraint -->
<!--                    <xsl:otherwise>-->
                        
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">other_participations</xsl:attribute>
                            <xsl:attribute name="type">oe:PARTICIPATION</xsl:attribute>
                            <xsl:attribute name="minOccurs">0</xsl:attribute>
                            <xsl:attribute name="maxOccurs">unbounded</xsl:attribute>
                        </xsl:element>
                        
                    <!--</xsl:otherwise>
                </xsl:choose>-->
        
    </xsl:template>
    
    <!-- construct DV_TEXT/DV_CODED_TEXT for RM attribute -->
    <xsl:template name="constructTextAndCodedTextRMAttribute">
        <xsl:param name="rm-attribute-children-context"/><!-- pointer to this current RM attribute's children xml node context. -->
        
        <xsl:choose>
            
            <!-- DV_TEXT RM attribute -->
            <xsl:when test="$rm-attribute-children-context/oe:rm_type_name='DV_TEXT'">
                <xsl:attribute name="type">oe:DV_TEXT</xsl:attribute>
            </xsl:when>
            
            <!-- DV_CODED_TEXT RM attribute using EXTERNAL terminology-->
            <xsl:when test="$rm-attribute-children-context/oe:children[oe:rm_type_name='DV_CODED_TEXT']/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children[@xsi:type='C_CODE_REFERENCE']">
                <xsl:attribute name="type">oe:DV_CODED_TEXT</xsl:attribute>
            </xsl:when>
            
            <!-- DV_CODED_TEXT RM attribute using LOCAL terminology-->
            <xsl:otherwise>
                
                <xsl:element name="xs:complexType">
                    <xsl:element name="xs:sequence">
                        
                        <!-- defining_code is mandatory -->
                        <xsl:element name="xs:element">
                            <xsl:attribute name="name">defining_code</xsl:attribute>
                            <xsl:element name="xs:complexType">
                                <xsl:element name="xs:sequence">
                                    <xsl:element name="xs:element">
                                        <xsl:attribute name="name">terminology_id</xsl:attribute>
                                        <xsl:element name="xs:complexType">
                                            <xsl:element name="xs:sequence">
                                                <xsl:element name="xs:element">
                                                    <xsl:attribute name="name">value</xsl:attribute>
                                                    <xsl:attribute name="fixed">local</xsl:attribute>
                                                    <xsl:attribute name="type">xs:token</xsl:attribute>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:element>
                                    
                                    <xsl:choose>
                                        
                                        <!-- LOCAL terminology used and there are NO constrained set of valid code_strings specified for some reason -->
                                        <xsl:when test="string-length($rm-attribute-children-context/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list)>0">
                                            <!-- code_string is mandatory with enumeration of valid values -->
                                            <xsl:element name="xs:element">
                                                <xsl:attribute name="name">code_string</xsl:attribute>
                                                
                                                <xsl:choose>
                                                    <xsl:when test="count($rm-attribute-children-context/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list)>1">
                                                        <xsl:element name="xs:simpleType">
                                                            <xsl:element name="xs:restriction">
                                                                <xsl:attribute name="base">xs:string</xsl:attribute>
                                                                <xsl:for-each select="$rm-attribute-children-context/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list">
                                                                    <xsl:element name="xs:enumeration">
                                                                        <xsl:attribute name="value">
                                                                            <xsl:value-of select="."/>
                                                                        </xsl:attribute>
                                                                    </xsl:element>
                                                                </xsl:for-each>
                                                            </xsl:element>
                                                        </xsl:element>
                                                    </xsl:when>
                                                    <xsl:when test="count($rm-attribute-children-context/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list)=1">
                                                        <xsl:attribute name="fixed"><xsl:value-of select="$rm-attribute-children-context/oe:attributes[oe:rm_attribute_name='defining_code']/oe:children/oe:code_list"/></xsl:attribute>
                                                        <xsl:attribute name="type">xs:string</xsl:attribute>
                                                    </xsl:when>
                                                </xsl:choose>
                                                
                                            </xsl:element>
                                        </xsl:when>
                                        
                                        <!-- code_string is mandatory with NO enumeration -->
                                        <xsl:otherwise>
                                            <xsl:element name="xs:element">
                                                <xsl:attribute name="name">code_string</xsl:attribute>
                                                <xsl:attribute name="type">xs:string</xsl:attribute>
                                            </xsl:element>
                                        </xsl:otherwise>
                                        
                                    </xsl:choose>
                                    
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                        
                    </xsl:element>
                </xsl:element>
            </xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="construct-duration-regex-pattern">
        <xsl:param name="pattern"/>
        
        <!-- <xs:pattern value="P(\d+Y)?(\d+M)?(\d+W)?(\d+D)?(T(\d+H)?(\d+M)?(\d+(\.\d+)?S)?)?"/> -->
               
        <xsl:choose>
            
            <!-- contains Time segment -->
            <xsl:when test="contains($pattern, 'T')">
            
                <!-- process date segment -->
                <xsl:call-template name="construct-regex-for-iso-date-segment">
                    <xsl:with-param name="date-segment"><xsl:value-of select="substring-before($pattern, 'T')"/></xsl:with-param>
                </xsl:call-template>
                
                <xsl:text>(T</xsl:text>
                
                <!-- process time segment -->
                <xsl:call-template name="construct-regex-for-iso-time-segment">
                    <xsl:with-param name="time-segment"><xsl:value-of select="substring-after($pattern, 'T')"/></xsl:with-param>
                </xsl:call-template>
                
                <xsl:text>)?</xsl:text>
                
            </xsl:when>
            
            <!-- contains Date segment only -->
            <xsl:when test="not(contains($pattern, 'T'))">
                <xsl:call-template name="construct-regex-for-iso-date-segment">
                    <xsl:with-param name="date-segment"><xsl:value-of select="$pattern"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            
            <xsl:otherwise><xsl:value-of select="pattern"/></xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="construct-regex-for-iso-date-segment">
        <xsl:param name="date-segment"/>
        
        <!-- <xs:pattern value="P(\d+Y)?(\d+M)?(\d+W)?(\d+D)?(T(\d+H)?(\d+M)?(\d+(\.\d+)?S)?)?"/> -->
        
        <xsl:choose>
            <xsl:when test="contains($date-segment, 'Y')">
                <xsl:call-template name="construct-regex-for-iso-date-segment">
                    <xsl:with-param name="date-segment"><xsl:value-of select="substring-before($date-segment, 'Y')"/></xsl:with-param>
                </xsl:call-template>
                <xsl:text>(\d+[yY])?</xsl:text>
                <xsl:call-template name="construct-regex-for-iso-date-segment">
                    <xsl:with-param name="date-segment"><xsl:value-of select="substring-after($date-segment, 'Y')"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($date-segment, 'M')">
                <xsl:call-template name="construct-regex-for-iso-date-segment">
                    <xsl:with-param name="date-segment"><xsl:value-of select="substring-before($date-segment, 'M')"/></xsl:with-param>
                </xsl:call-template>
                <xsl:text>(\d+[mM])?</xsl:text>
                <xsl:call-template name="construct-regex-for-iso-date-segment">
                    <xsl:with-param name="date-segment"><xsl:value-of select="substring-after($date-segment, 'M')"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($date-segment, 'W')">
                <xsl:call-template name="construct-regex-for-iso-date-segment">
                    <xsl:with-param name="date-segment">
                        <xsl:value-of select="substring-before($date-segment, 'W')"/>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:text>(\d+[wW])?</xsl:text>
                <xsl:call-template name="construct-regex-for-iso-date-segment">
                    <xsl:with-param name="date-segment"><xsl:value-of select="substring-after($date-segment, 'W')"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($date-segment, 'D')">
                <xsl:call-template name="construct-regex-for-iso-date-segment">
                    <xsl:with-param name="date-segment"><xsl:value-of select="substring-before($date-segment, 'D')"/></xsl:with-param>
                </xsl:call-template>
                <xsl:text>(\d+[dD])?</xsl:text>
                <xsl:call-template name="construct-regex-for-iso-date-segment">
                    <xsl:with-param name="date-segment"><xsl:value-of select="substring-after($date-segment, 'D')"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$date-segment"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="construct-regex-for-iso-time-segment">
        <xsl:param name="time-segment"/>

        <xsl:choose>
            <xsl:when test="contains($time-segment, 'H')">
                <xsl:call-template name="construct-regex-for-iso-time-segment">
                    <xsl:with-param name="time-segment"><xsl:value-of select="substring-before($time-segment, 'H')"/></xsl:with-param>
                </xsl:call-template>
                <xsl:text>(\d+[hH])?</xsl:text>
                <xsl:call-template name="construct-regex-for-iso-time-segment">
                    <xsl:with-param name="time-segment"><xsl:value-of select="substring-after($time-segment, 'H')"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($time-segment, 'M')">
                <xsl:call-template name="construct-regex-for-iso-time-segment">
                    <xsl:with-param name="time-segment"><xsl:value-of select="substring-before($time-segment, 'M')"/></xsl:with-param>
                </xsl:call-template>
                <xsl:text>(\d+[mM])?</xsl:text>
                <xsl:call-template name="construct-regex-for-iso-time-segment">
                    <xsl:with-param name="time-segment"><xsl:value-of select="substring-after($time-segment, 'M')"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($time-segment, 'S')">
                <xsl:call-template name="construct-regex-for-iso-time-segment">
                    <xsl:with-param name="time-segment"><xsl:value-of select="substring-before($time-segment, 'S')"/></xsl:with-param>
                </xsl:call-template>
                <xsl:text>(\d+(\.\d+)?[sS])?</xsl:text>
                <xsl:call-template name="construct-regex-for-iso-time-segment">
                    <xsl:with-param name="time-segment"><xsl:value-of select="substring-after($time-segment, 'S')"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$time-segment"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template name="formatPropertyUnitName">
        <xsl:param name="property-unit"/>
        
        <xsl:choose>
            
            <!-- TODO: 'qualified real' quantity property e.g. unit = 10*3 -->
            
            <!-- replace Å with 'armstrong' -->
            <xsl:when test="contains($property-unit, 'Å')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-before($property-unit, 'Å')"/>
                </xsl:call-template>armstrong<xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-after($property-unit, 'Å')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- replace µ with 'micro_[unit]' -->
            <xsl:when test="contains($property-unit, 'µ')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-before($property-unit, 'µ')"/>
                </xsl:call-template>micro_<xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-after($property-unit, 'µ')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- replace ° with 'degree' -->
            <xsl:when test="contains($property-unit, '°')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-before($property-unit, '°')"/>
                </xsl:call-template>degree<xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-after($property-unit, '°')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- replace % with 'percent' -->
            <xsl:when test="contains($property-unit, '%')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-before($property-unit, '%')"/>
                </xsl:call-template>percent<xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-after($property-unit, '%')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- remove amphersand -->
            <xsl:when test="contains($property-unit, '&amp;')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-before($property-unit, '&amp;')"/>
                </xsl:call-template>
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-after($property-unit, '&amp;')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- replace / with 'per' -->
            <xsl:when test="contains($property-unit, '/')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-before($property-unit, '/')"/>
                </xsl:call-template>_per_<xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-after($property-unit, '/')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- replace space with underscore -->
            <xsl:when test="contains($property-unit, ' ')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-before($property-unit, ' ')"/>
                </xsl:call-template>_<xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-after($property-unit, ' ')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- replace period with underscore -->
            <xsl:when test="contains($property-unit, '.')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-before($property-unit, '.')"/>
                </xsl:call-template>_<xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-after($property-unit, '.')"/>
                </xsl:call-template>
            </xsl:when>
            
        	<!-- replace comma  with underscore -->
        	<xsl:when test="contains($property-unit, ',')">
        		<xsl:call-template name="formatPropertyUnitName">
        			<xsl:with-param name="property-unit" select="substring-before($property-unit, ',')"/>
        		</xsl:call-template>_<xsl:call-template name="formatPropertyUnitName">
        			<xsl:with-param name="property-unit" select="substring-after($property-unit, ',')"/>
        		</xsl:call-template>
        	</xsl:when>
        	
            
            <!-- replace open bracket -->
            <xsl:when test="contains($property-unit, '(')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-before($property-unit, '(')"/>
                </xsl:call-template>_<xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-after($property-unit, '(')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- replace closing bracket -->
            <xsl:when test="contains($property-unit, ')')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-before($property-unit, ')')"/>
                </xsl:call-template>_<xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-after($property-unit, ')')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- replace open square bracket -->
            <xsl:when test="contains($property-unit, '[')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-before($property-unit, '[')"/>
                </xsl:call-template>_<xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-after($property-unit, '[')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- replace closing bracket -->
            <xsl:when test="contains($property-unit, ']')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-before($property-unit, ']')"/>
                </xsl:call-template>_<xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-after($property-unit, ']')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- replace open curly bracket -->
            <xsl:when test="contains($property-unit, '{')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-before($property-unit, '{')"/>
                </xsl:call-template>_<xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-after($property-unit, '{')"/>
                </xsl:call-template>
            </xsl:when>
            
            <!-- replace closing curly bracket -->
            <xsl:when test="contains($property-unit, '}')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-before($property-unit, '}')"/>
                </xsl:call-template>_<xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit" select="substring-after($property-unit, '}')"/>
                </xsl:call-template>
            </xsl:when>
            
            <xsl:otherwise><xsl:value-of select="$property-unit" disable-output-escaping="yes"/></xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>
    
    
    <xsl:template name="is-fixed-attribute-required">
        <xsl:if test="$fixed-is-required='true'">
            <xsl:attribute name="use">required</xsl:attribute>
        </xsl:if>
    </xsl:template>
    
    <!--<xsl:template name="LookupPropertyUnitDataByUnit">
        <xsl:param name="property-unit"/>
        
        <xsl:variable name="property-top" select="document($property-unit-xml-document-path)/prop:PropertyUnits"/>-->
        <!--  E.g. <Unit property_id="0" Text="m" name="meter" conversion="1" primary="true" />-->
        
        <!-- Format the property unit name so that it is a valid xml element name -->
        <!--<xsl:call-template name="formatPropertyUnitName">
            <xsl:with-param name="property-unit-name"><xsl:value-of select="$property-top/prop:Unit[@Text=$property-unit]/@name"/></xsl:with-param>
        </xsl:call-template>
        
    </xsl:template>-->
    
    <!--<xsl:template name="formatPropertyUnitName">
        <xsl:param name="property-unit-name"/>
        
        <xsl:choose>-->
            
            <!-- replace space with underscore -->
            <!--<xsl:when test="contains($property-unit-name, ' ')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit-name" select="substring-before($property-unit-name, ' ')"/>
                </xsl:call-template>_<xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit-name" select="substring-after($property-unit-name, ' ')"/>
                </xsl:call-template>
            </xsl:when>-->
            
            <!-- remove period -->
            <!--<xsl:when test="contains($property-unit-name, '.')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit-name" select="substring-before($property-unit-name, '.')"/>
                </xsl:call-template>
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit-name" select="substring-after($property-unit-name, '.')"/>
                </xsl:call-template>
            </xsl:when>-->
            
            <!-- remove open bracket -->
            <!--<xsl:when test="contains($property-unit-name, '(')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit-name" select="substring-before($property-unit-name, '(')"/>
                </xsl:call-template>
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit-name" select="substring-after($property-unit-name, '(')"/>
                </xsl:call-template>
            </xsl:when>-->
            
            <!-- remove closing bracket -->
            <!--<xsl:when test="contains($property-unit-name, ')')">
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit-name" select="substring-before($property-unit-name, ')')"/>
                </xsl:call-template>
                <xsl:call-template name="formatPropertyUnitName">
                    <xsl:with-param name="property-unit-name" select="substring-after($property-unit-name, ')')"/>
                </xsl:call-template>
            </xsl:when>
            
            <xsl:otherwise><xsl:value-of select="$property-unit-name" disable-output-escaping="yes"/></xsl:otherwise>
            
        </xsl:choose>
        
    </xsl:template>-->
    
</xsl:stylesheet>
