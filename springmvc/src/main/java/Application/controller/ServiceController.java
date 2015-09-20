package Application.controller;

import org.apache.log4j.Logger;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ServiceController {

	private static final Logger logger = Logger.getLogger(ServiceController.class);
	
    @RequestMapping(value = "/example")
    public @ResponseBody String updateEnvironmentConfigurations() {
        logger.info("Request received for /example");
        return "Foo";
    }
}
