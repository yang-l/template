package Application.model;

import java.util.Map;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class item {

	private String string;
	private Map<String, String[]> stringMap;

        @SerializedName(".VERSION")
        private String version;

        public String getString() {
		return string;
	}
	public void setString(String string) {
		this.string = string;
	}
	public Map<String, String[]> getStringMap() {
		return stringMap;
	}
	public void setStringMap(Map<String, String[]> stringMap) {
		this.stringMap = stringMap;
	}

}
