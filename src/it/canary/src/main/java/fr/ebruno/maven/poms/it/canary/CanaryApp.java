package fr.ebruno.maven.poms.it.canary;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Canary application class.
 *
 * <p>
 * Exercises the parent-managed Jackson version (via the Jackson BOM) and the
 * parent-managed compiler settings (Java release 25).
 */
public final class CanaryApp {

    private CanaryApp() {
        // utility class
    }

    /**
     * Builds a small JSON payload with Jackson and returns it as a string.
     *
     * @return the JSON payload, e.g. {"status":"ok","java":25}
     */
    public static String ping() {
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode node = mapper.createObjectNode();
        node.put("status", "ok");
        node.put("java", Runtime.version().feature());
        try {
            return mapper.writeValueAsString(node);
        } catch (JsonProcessingException e) {
            throw new IllegalStateException("Unable to serialize canary payload", e);
        }
    }

    public static void main(String[] args) {
        System.out.println(ping());
    }
}
