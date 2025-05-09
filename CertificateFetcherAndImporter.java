import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLPeerUnverifiedException;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.net.URL;
import java.security.KeyStore;
import java.security.cert.Certificate;
import java.security.cert.X509Certificate;

public class CertificateFetcherAndImporter {

    public static void main(String[] args) {
        // List of URLs to fetch certificates from
        String[] urls = {
                "https://example.com",
                "https://anotherdomain.com",
                "https://yetanotherdomain.com"
        };

        // Hardcoded path to JDK cacerts file
        String cacertsPath = "C:\\Program Files\\Java\\jdk-17\\lib\\security\\cacerts";

        // Hardcoded cacerts password
        String cacertsPassword = "changeit";

        try {
            // Load existing cacerts keystore
            FileInputStream is = new FileInputStream(cacertsPath);
            KeyStore keystore = KeyStore.getInstance(KeyStore.getDefaultType());
            keystore.load(is, cacertsPassword.toCharArray());
            is.close();

            for (String urlString : urls) {
                System.out.println("\n🔗 Processing URL: " + urlString);
                try {
                    URL url = new URL(urlString);
                    HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
                    conn.connect();
                    Certificate[] certs = conn.getServerCertificates();
                    X509Certificate serverCert = (X509Certificate) certs[0];

                    System.out.println("  - Subject: " + serverCert.getSubjectDN());
                    System.out.println("  - Issuer: " + serverCert.getIssuerDN());

                    // Create an alias based on hostname
                    String alias = url.getHost();

                    // Add the certificate into keystore
                    keystore.setCertificateEntry(alias, serverCert);
                    System.out.println("  ✅ Certificate imported for alias: " + alias);

                } catch (SSLPeerUnverifiedException e) {
                    System.err.println("  ❌ SSL Peer Unverified for URL: " + urlString + " - " + e.getMessage());
                } catch (Exception e) {
                    System.err.println("  ❌ Error fetching certificate for URL: " + urlString + " - " + e.getMessage());
                }
            }

            // Save updated keystore after processing all URLs
            try (FileOutputStream out = new FileOutputStream(cacertsPath)) {
                keystore.store(out, cacertsPassword.toCharArray());
            }

            System.out.println("\n✅ All certificates processed. Keystore updated.");

        } catch (Exception e) {
            System.err.println("❌ General error initializing keystore or file system: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
//How to run
//javac CertificateFetcherAndImporter.java
//java CertificateFetcherAndImporter

