package org.xtuml.bp.xtext.masl.validation

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.serializer.ISerializer
import org.xtuml.bp.xtext.masl.MASLExtensions
import org.xtuml.bp.xtext.masl.masl.structure.DomainFunctionDeclaration
import org.xtuml.bp.xtext.masl.masl.structure.DomainServiceDeclaration
import org.xtuml.bp.xtext.masl.masl.structure.ObjectDefinition
import org.xtuml.bp.xtext.masl.masl.structure.ObjectFunctionDeclaration
import org.xtuml.bp.xtext.masl.masl.structure.ObjectServiceDeclaration
import org.xtuml.bp.xtext.masl.masl.structure.Parameterized
import org.xtuml.bp.xtext.masl.masl.structure.StateDeclaration
import org.xtuml.bp.xtext.masl.masl.structure.TerminatorFunctionDeclaration
import org.xtuml.bp.xtext.masl.masl.structure.TerminatorServiceDeclaration
import org.xtuml.bp.xtext.masl.typesystem.MaslTypeProvider
import org.xtuml.bp.xtext.masl.masl.structure.TerminatorDefinition

class SignatureProvider {
	
	@Inject extension MaslTypeProvider
	@Inject extension MASLExtensions
	@Inject extension ISerializer serializer

	def getParametersAsString(EObject possiblyParameterized) {
		if (possiblyParameterized instanceof Parameterized)
			'(' + (possiblyParameterized as Parameterized).parameters.map[maslType.toString].join(',') + ')'
		else
			''
	}
	
	def String getImplementationSignature(EObject it) {
		switch it {
			DomainFunctionDeclaration: '''
				«visibility + ' '?:''»function «domainName»::«name»(«
					FOR p: parameters SEPARATOR ','»«
						p.name»: «p.mode» «p.type.serialize»«
					ENDFOR») return «returnType.serialize» is
				begin
				end
			'''
			DomainServiceDeclaration: '''
				«visibility + ' '?:''»service «domainName»::«name»(«
					FOR p: parameters SEPARATOR ','»«
						p.name»: «p.mode» «p.type.serialize»«
					ENDFOR») is
				begin
				end
			'''
			ObjectFunctionDeclaration: '''
				«visibility + ' '?:''»«IF instance»instance «ENDIF»function «domainName»::«objectName».«name»(«
					FOR p: parameters SEPARATOR ','»«
						p.name»: «p.mode» «p.type.serialize»«
					ENDFOR») return «returnType.serialize» is
				begin
				end
			'''
			ObjectServiceDeclaration: '''
				«visibility + ' '?:''»«IF instance»instance «ENDIF»service «domainName»::«objectName».«name»(«
					FOR p: parameters SEPARATOR ','»«
						p.name»: «p.mode» «p.type.serialize»«
					ENDFOR») is
				begin
				end
			'''
			TerminatorFunctionDeclaration: '''
				«visibility + ' '?:''»function «domainName»::«terminatorName»~>«name»(«
					FOR p: parameters SEPARATOR ','»«
						p.name»: «p.mode» «p.type.serialize»«
					ENDFOR») return «returnType.serialize» is
				begin
				end
			'''
			TerminatorServiceDeclaration: '''
				«visibility + ' '?:''»service «domainName»::«terminatorName»~>«name»(«
					FOR p: parameters SEPARATOR ','»«
						p.name»: «p.mode» «p.type.serialize»«
					ENDFOR») is
				begin
				end
			'''
			StateDeclaration: '''
				«type» state «domainName»::«objectName».«name»(«
									FOR p: parameters SEPARATOR ','»«
										p.name»: «p.mode» «p.type.serialize»«
									ENDFOR») is
				begin
				end
			'''
		} 
	}
	
	private def getObjectName(EObject it) {
		(eContainer as ObjectDefinition).name
	}
	
	private def getTerminatorName(EObject it) {
		(eContainer as TerminatorDefinition).name
	}
}
