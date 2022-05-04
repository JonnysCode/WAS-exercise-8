package wot;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import cartago.*;

public class HypermediaCrawlerTest {

    private static final String BASE_URL = "http://api.interactions.ics.unisg.ch/hypermedia-environment/was/";
    private static final String FILE_PATH = "./additional-resources/discovered-org.xml";

    public void searchEnvironment(String relationType) {

        List<String> discovered = new ArrayList<String>();
        List<String> checked = new ArrayList<String>();

        discovered.add("581b07c7dff45162");

        while (!discovered.isEmpty()) {
            String next = discovered.remove(0);
            checked.add(next);

            Document doc;
            try {
                doc = Jsoup.connect(BASE_URL + next).get();

                Elements links = doc.select("a");
                for (Element link : links) {
                    String href = link.attr("href");

                    if (link.toString().contains(relationType)) {
                        System.out.println(link);
                        System.out.println("Discovered relation at " + href);
                        fetchToFile(href);
                        return;
                    }

                    if (!checked.contains(href) && !discovered.contains(href)) {
                        discovered.add(href);
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void fetchToFile(String url) throws IOException {
        Document doc = Jsoup.connect(url).get();

        final File f = new File(FILE_PATH);
        FileUtils.writeStringToFile(f, doc.outerHtml(), StandardCharsets.UTF_8);
    }

    public static void main(String[] args) {
        HypermediaCrawlerTest hc = new HypermediaCrawlerTest();
        hc.searchEnvironment("Monitor Temperature");
    }
}
