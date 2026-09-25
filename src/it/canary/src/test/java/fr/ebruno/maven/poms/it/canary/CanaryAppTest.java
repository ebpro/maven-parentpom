package fr.ebruno.maven.poms.it.canary;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

/**
 * Canary test.
 *
 * <p>
 * Verifies that the parent-managed JUnit 6 version (via the JUnit BOM) and
 * the parent-managed surefire configuration actually run tests in a child
 * project.
 */
class CanaryAppTest {

    @Test
    void pingReturnsValidJson() {
        String result = CanaryApp.ping();

        assertNotNull(result);
        assertTrue(result.contains("\"status\":\"ok\""));
        // The enforcer allows Java [25,), so assert the actual runtime
        // feature rather than a hardcoded value.
        assertTrue(result.contains("\"java\":" + Runtime.version().feature()));
    }
}
