/*
   Copyright 2022 WeAreFrank!

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
package org.frankframework.management.bus.endpoints;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.frankframework.management.bus.TopicSelector;
import org.frankframework.management.bus.message.JsonMessage;
import org.springframework.messaging.Message;

import org.frankframework.configuration.Configuration;
import org.frankframework.core.Adapter;
import org.frankframework.core.HasPhysicalDestination;
import org.frankframework.core.IListener;
import org.frankframework.core.IPipe;
import org.frankframework.core.ISender;
import org.frankframework.core.PipeLine;
import org.frankframework.management.bus.BusAware;
import org.frankframework.management.bus.BusTopic;
import org.frankframework.pipes.MessageSendingPipe;
import org.frankframework.receivers.Receiver;

import javax.annotation.security.RolesAllowed;

@BusAware("frank-management-bus")
public class ConnectionOverview extends BusEndpointBase {

	@TopicSelector(BusTopic.CONNECTION_OVERVIEW)
	@RolesAllowed({"IbisObserver", "IbisDataAdmin", "IbisAdmin", "IbisTester"})
	public Message<String> getAllConnections(Message<?> message) {
		List<Object> connectionsIncoming = new LinkedList<>();

		for(Configuration config : getIbisManager().getConfigurations()) {
			for(Adapter adapter: config.getRegisteredAdapters()) {
				for (Receiver<?> receiver: adapter.getReceivers()) {
					IListener<?> listener=receiver.getListener();
					if (listener instanceof HasPhysicalDestination) {
						String destination = ((HasPhysicalDestination)receiver.getListener()).getPhysicalDestinationName();
						String domain = ((HasPhysicalDestination)receiver.getListener()).getDomain();
						connectionsIncoming.add(addToMap(adapter.getName(), destination, listener.getName(), "Inbound", domain));
					}
				}

				PipeLine pipeline = adapter.getPipeLine();
				for (IPipe pipe : pipeline.getPipes()) {
					if (pipe instanceof MessageSendingPipe) {
						MessageSendingPipe msp=(MessageSendingPipe)pipe;
						ISender sender = msp.getSender();
						if (sender instanceof HasPhysicalDestination) {
							String destination = ((HasPhysicalDestination)sender).getPhysicalDestinationName();
							String domain = ((HasPhysicalDestination)sender).getDomain();
							connectionsIncoming.add(addToMap(adapter.getName(), destination, sender.getName(), "Outbound", domain));
						}
						IListener<?> listener = msp.getListener();
						if (listener instanceof HasPhysicalDestination) {
							String destination = ((HasPhysicalDestination)listener).getPhysicalDestinationName();
							String domain = ((HasPhysicalDestination)listener).getDomain();
							connectionsIncoming.add(addToMap(adapter.getName(), destination, listener.getName(), "Inbound", domain));
						}
					}
				}
			}
		}

		Map<String, List<Object>> allConnections = new LinkedHashMap<>();
		allConnections.put("data", connectionsIncoming);

		return new JsonMessage(allConnections);
	}

	private Map<String, Object> addToMap(String adapterName, String destination, String name, String direction, String domain) {
		Map<String, Object> connection = new HashMap<>();
		connection.put("adapterName", adapterName);
		connection.put("destination", destination);
		connection.put("componentName", name);
		connection.put("direction", direction);
		connection.put("domain", domain);
		return connection;
	}
}
