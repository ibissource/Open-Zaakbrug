/*
   Copyright 2013 Nationale-Nederlanden, 2020, 2022 WeAreFrank!

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
package org.frankframework.senders;

import lombok.Getter;
import lombok.Setter;
import org.frankframework.configuration.ConfigurationException;
import org.frankframework.core.ISenderWithParameters;
import org.frankframework.core.PipeLineSession;
import org.frankframework.core.SenderException;
import org.frankframework.core.SenderResult;
import org.frankframework.core.TimeoutException;
import org.frankframework.doc.Category;
import org.frankframework.parameters.Parameter;
import org.frankframework.parameters.ParameterList;
import org.frankframework.stream.Message;
import org.frankframework.validation.XercesXmlValidator;


/**
 * Sender that validates the input message against a XML Schema.
 *
 * N.B. noNamespaceSchemaLocation may contain spaces, but not if the schema is stored in a .jar or .zip file on the class path.
 *
 * @author  Gerrit van Brakel
 * @since
 */
@Category("Advanced")
public class XmlValidatorSender extends XercesXmlValidator implements ISenderWithParameters {

	private @Getter @Setter String name;

	@Override
	public void configure() throws ConfigurationException {
		configure(this);
	}

	@Override
	public void close() throws SenderException {
	}
	@Override
	public void open() throws SenderException {
	}

	@Override
	public void addParameter(Parameter p) {
		// class doesn't really have parameters, but implements ISenderWithParameters to get ParameterResolutionContext in sendMessage(), to obtain session
	}

	@Override
	public ParameterList getParameterList() {
		// class doesn't really have parameters, but implements ISenderWithParameters to get ParameterResolutionContext in sendMessage(), to obtain session
		return null;
	}

	@Override
	public SenderResult sendMessage(Message message, PipeLineSession session) throws SenderException, TimeoutException {
		String fullReasons="";
		try {
			ValidationResult validationResult = validate(message, session, getLogPrefix(),null,null);

			if (validationResult == ValidationResult.VALID || validationResult == ValidationResult.VALID_WITH_WARNINGS) {
				return new SenderResult(message);
			}
			fullReasons = validationResult.getEvent(); // TODO: find real fullReasons
			if (isThrowException()) {
				throw new SenderException(fullReasons);
			}
			log.warn(fullReasons);
			return new SenderResult(message);
		} catch (Exception e) {
			if (isThrowException()) {
				throw new SenderException(e);
			}
			log.warn(fullReasons, e);
			return new SenderResult(message);
		}
	}

	@Override
	public boolean isSynchronous() {
		return true;
	}

	protected String getLogPrefix() {
		return "["+this.getClass().getName()+"] ["+getName()+"] ";
	}

}
