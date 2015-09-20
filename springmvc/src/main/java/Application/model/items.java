package Application.model;

import java.util.HashMap;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class items extends HashMap<String, item>{
	private static final long serialVersionUID = 1L;
}
