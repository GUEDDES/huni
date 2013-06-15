
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:s="http://www.w3.org/2005/sparql-results#" xmlns:lookup="local-namespace" exclude-result-prefixes="s">
	
	<!--
		generic stylesheet as a fallback for resources whose classes are not specifically handled by a page template
	-->
	<xsl:import href="sparql-results-to-html.xsl"/>
	
	<xsl:key name="graph-uris" match="s:binding[@name='g']" use="."/>
	<xsl:key name="results-by-graph" match="s:result" use="s:binding[@name='g']"/>
	<xsl:key name="results-by-graph-and-subject" match="s:result" use="concat(s:binding[@name='g'], ' ', s:binding[@name='s'])"/>
	
	<xsl:variable name="resource" select="/s:sparql/s:results/s:result[1]/s:binding[@name='resource']/s:uri"/>
	<xsl:variable name="person-template" select="document('/linked-data/templates/person.html')"/>
	<xsl:variable name="results" select="/s:sparql/s:results/s:result"/>
	
	<!-- See if there is a page template available to process a resource of this class; if so, use it -->
	<!-- If not, fall back to the generic stylesheet -->
	<xsl:template match="/">
		<xsl:variable name="root-resource" select="string(/s:sparql/s:results/s:result/s:binding[@name='resource']/s:uri)"/>
		<xsl:variable name="root-resource-class" select="string(/s:sparql/s:results/s:result[s:binding[@name='s']/s:uri = $root-resource][s:binding[@name='p']/s:uri='http://www.w3.org/1999/02/22-rdf-syntax-ns#type']/s:binding[@name='o']/s:uri)"/>
		<xsl:choose>
			<xsl:when test="$root-resource-class='http://erlangen-crm.org/current/E21_Person'">
				<xsl:apply-templates select="$person-template/*" mode="graph">
					<xsl:with-param name="current-node" select="$root-resource"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<!-- generic styling -->
				<xsl:apply-imports/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- 
	two modes: "graph" and "triple"
	In graph mode, handle any graph-repetition attribute attached to the template node,
	and apply templates to the same template node in "triple" mode.
	In triple mode, handle any triple repetition attributes, and apply templates to child nodes of the template node, in graph mode.
	-->
	
	<xsl:template match="text()|*[not(@graph)]" mode="graph">
		<xsl:param name="current-node"/>
		<xsl:param name="current-graph" select="/.."/>
		<xsl:apply-templates select="." mode="triple">
			<xsl:with-param name="current-graph" select="$current-graph"/>
			<xsl:with-param name="current-node" select="$current-node"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- handle any graph-switching code attached to template node -->
	<xsl:template match="*" mode="graph">
		<xsl:param name="current-node"/>
		<xsl:param name="current-graph" select="/.."/>
		<xsl:choose>
			<xsl:when test="@graph='any'">
				<xsl:apply-templates select="." mode="triple">
					<xsl:with-param name="current-graph" select="''"/>
					<xsl:with-param name="current-node" select="$current-node"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="@graph='each'">
				<xsl:variable name="current-template" select="."/>
				<!-- repeat for each graph
					=> apply templates to current template
				-->
				<xsl:for-each select="$results">
					<!-- loop over each unique graph uri -->
					<xsl:if test="not(
						preceding-sibling::s:result[
							s:binding[@name='g']/s:uri = current()/s:binding[@name='g']/s:uri
						]
					)">
						<xsl:variable name="graph" select="s:binding[@name='g']/s:uri/text()"/>
						<!-- apply templates to triples whose subject is the current node, within the current graph -->
						<!-- if the current graph doesn't contain any triples with that subject, ignore the graph -->
						<xsl:if test="$results[s:binding[@name='g']/s:uri = $graph][s:binding[@name='s']/s:uri = $current-node]">
							<xsl:apply-templates mode="triple" select="$current-template">
								<xsl:with-param name="current-node" select="$current-node"/>
								<xsl:with-param name="current-graph" select="$graph"/>
							</xsl:apply-templates>
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="triple">
		<xsl:param name="current-node"/>
		<xsl:param name="current-graph"/>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="triple">
				<xsl:with-param name="current-node" select="$current-node"/>
				<xsl:with-param name="current-graph" select="$current-graph"/>
			</xsl:apply-templates>
			<xsl:apply-templates mode="graph">
				<xsl:with-param name="current-node" select="$current-node"/>
				<xsl:with-param name="current-graph" select="$current-graph"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@for-each" mode="triple"/>
	
	<xsl:template match="*[@for-each]" mode="triple">
		<xsl:param name="current-node"/>
		<xsl:param name="current-graph"/><!--
		<xsl:comment>for-each="<xsl:value-of select="@for-each"/>" current template="<xsl:value-of select="local-name()"/>" current-node="<xsl:value-of select="$current-node"/>" current-graph="<xsl:value-of select="$current-graph"/>"</xsl:comment>-->
		<xsl:call-template name="evaluate-expression">
			<xsl:with-param name="expression" select="@for-each"/>
			<xsl:with-param name="current-node" select="$current-node"/>
			<xsl:with-param name="current-graph" select="$current-graph"/>
			<xsl:with-param name="continuation" select="'for-each'"/>
		</xsl:call-template>
	</xsl:template>	
	
	<xsl:template match="@*" mode="triple">
		<xsl:copy/>
	</xsl:template>
	
	<xsl:template match="@if" mode="triple"/>
	
	<xsl:template match="text()[contains(., '{')]" mode="triple">
		<xsl:param name="current-node"/>
		<xsl:param name="current-graph"/>
		<xsl:call-template name="evaluate-expressions">
			<xsl:with-param name="current-node" select="$current-node"/>
			<xsl:with-param name="current-graph" select="$current-graph"/>
			<xsl:with-param name="continuation" select="'value-of'"/>
		</xsl:call-template>
	</xsl:template>
	
	<!-- expand value templates e.g. {http://xmlns.com/foaf/0.1/isPrimaryTopicOf} in attribute values -->
	<xsl:template match="@*[contains(., '{')]" mode="triple">
		<xsl:param name="current-node"/>
		<xsl:param name="current-graph"/>
		<xsl:attribute name="{local-name(.)}">
			<xsl:call-template name="evaluate-expressions">
				<xsl:with-param name="current-node" select="$current-node"/>
				<xsl:with-param name="current-graph" select="$current-graph"/>
				<xsl:with-param name="continuation" select="'value-of'"/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="evaluate-expressions">
		<xsl:param name="text" select="."/>
		<xsl:param name="current-node"/>
		<xsl:param name="current-graph"/>
		<xsl:param name="continuation"/>
		<xsl:value-of select="substring-before($text, '{')"/>
		<xsl:call-template name="evaluate-expression">
			<xsl:with-param name="expression" select="substring-before(substring-after($text, '{'), '}')"/>
			<xsl:with-param name="current-node" select="$current-node"/>
			<xsl:with-param name="current-graph" select="$current-graph"/>
			<xsl:with-param name="continuation" select="$continuation"/>
		</xsl:call-template>
		<xsl:variable name="remainder" select="substring-after($text, '}')"/>
		<xsl:if test="$remainder">
			<xsl:call-template name="evaluate-expressions">
				<xsl:with-param name="text" select="$remainder"/>
				<xsl:with-param name="current-node" select="$current-node"/>
				<xsl:with-param name="current-graph" select="$current-graph"/>
				<xsl:with-param name="continuation" select="$continuation"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
		<!-- qaz evaluate the expression as a path of one or more predicates -->
		<!-- qaz evaluate within the context of the current graph -->
	<xsl:template name="evaluate-expression">
		<xsl:param name="expression"/>
		<xsl:param name="current-node"/>
		<xsl:param name="current-graph"/>
		<xsl:param name="continuation"/>
		<xsl:comment>Expression: <xsl:value-of select="$expression"/></xsl:comment>
		<!-- The current graph (if there is one) is the context for evaluating the expression -->
		<xsl:choose>
			<xsl:when test="$current-graph">
				<!-- we have a "current graph" - so select triples from that graph only -->
				<xsl:variable name="triples" select="
					$results
						[s:binding[@name='s']/s:uri/text() = $current-node]
						[s:binding[@name='p']/s:uri/text() = $expression]
						[s:binding[@name='g']/s:uri/text() = $current-graph]
				"/>
				<xsl:call-template name="execute-operation-on-triples">
					<xsl:with-param name="expression" select="$expression"/>
					<xsl:with-param name="triples" select="$triples"/>
					<xsl:with-param name="current-node" select="$current-node"/>
					<xsl:with-param name="current-graph" select="$current-graph"/>
					<xsl:with-param name="continuation" select="$continuation"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- no current graph - select any triples regardless of graph -->
				<xsl:variable name="triples" select="
					$results
						[s:binding[@name='s']/s:uri/text() = $current-node]
						[s:binding[@name='p']/s:uri/text() = $expression]
				"/>
				<xsl:call-template name="execute-operation-on-triples">
					<xsl:with-param name="expression" select="$expression"/>
					<xsl:with-param name="triples" select="$triples"/>
					<xsl:with-param name="current-node" select="$current-node"/>
					<xsl:with-param name="current-graph" select="$current-graph"/>
					<xsl:with-param name="continuation" select="$continuation"/>
				</xsl:call-template>				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="execute-operation-on-triples">
		<xsl:param name="expression"/>
		<xsl:param name="triples"/>
		<xsl:param name="current-node"/>
		<xsl:param name="current-graph"/>
		<xsl:param name="continuation"/>

		<xsl:variable name="current-template" select="."/>
		<xsl:choose>
			<xsl:when test="$expression='graph'">
				<!-- qaz if continuation is value-of -->
				<xsl:value-of select="$current-graph"/>
			</xsl:when>
			<xsl:when test="$expression='.'">
				<!-- "current node" -->
				<xsl:value-of select="$current-node"/>
			</xsl:when>
			<xsl:otherwise><!-- expression is a predicate - return all matching property values of $current-node -->
				<xsl:choose>
					<xsl:when test="$continuation='value-of'">
						<xsl:value-of select="$triples/s:binding[@name='o']/*"/>
					</xsl:when>
					<xsl:when test="$continuation='if'">
						<xsl:if test="$triples/s:binding[@name='o']/s:uri">
							<xsl:copy>
								<xsl:apply-templates select="@*" mode="triple"/>
								<xsl:apply-templates mode="graph">
									<xsl:with-param name="current-node" select="$current-node"/>
									<xsl:with-param name="current-graph" select="$current-graph"/>
								</xsl:apply-templates>
							</xsl:copy>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$continuation='for-each'">
						<xsl:for-each select="$triples/s:binding[@name='o']/s:uri">
							<xsl:variable name="resource" select="."/>
							<xsl:for-each select="$current-template">
								<xsl:copy>
									<xsl:apply-templates select="@*" mode="triple"/>
									<xsl:apply-templates mode="graph">
										<xsl:with-param name="current-node" select="$resource"/>
										<xsl:with-param name="current-graph" select="$current-graph"/>
									</xsl:apply-templates>
								</xsl:copy>
							</xsl:for-each>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

</xsl:stylesheet>