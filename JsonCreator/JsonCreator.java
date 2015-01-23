import com.google.common.base.Charsets;
import com.google.common.io.Files;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.*;
import java.util.*;

/**
 * Created by Lumia_Saki on 15/1/23.
 */
public class JsonCreator {
    static List<String> separateCSVFromFilePath(String path) throws FileNotFoundException {
        File file = new File(path);

        List<String> list = null;

        try {
            list = Files.readLines(file, Charsets.UTF_8);
        } catch (IOException e) {
            e.printStackTrace();
        }

        return list;
    }

    static JSONArray jsonCreator(String filePath,Integer keyCount) throws FileNotFoundException, JSONException, KeyValuePairException {
        List<String> stringList = separateCSVFromFilePath(filePath);

        JSONArray jsonArray = new JSONArray();

        Iterator<String> iterator = stringList.iterator();

        while (iterator.hasNext()) {
            String[] aLineArray = iterator.next().split(",");

            if (aLineArray.length/2 % keyCount != 0) {
                throw new KeyValuePairException("key-value pair no match");
            }

            JSONObject jsonObject = new JSONObject();

            for (Integer i = 0;i < aLineArray.length; i+=2) {
                jsonObject.put(aLineArray[i],aLineArray[i+1]);
            }

            jsonArray.put(jsonObject);

        }

        return jsonArray;
    }

    public static void main(String[] args) throws IOException, JSONException, KeyValuePairException {
        Scanner scanner = new Scanner(System.in);
        System.out.println("with format :fromPath keyCount toPath");

        String fromPath = null;
        Integer keyCount = null;
        String toPath = null;

//        while (scanner.hasNext()) {
            fromPath = scanner.next();
            keyCount = scanner.nextInt();
            toPath = scanner.next();
//        }

        JSONArray jsonArray = jsonCreator(fromPath,keyCount);

        String jsonString = jsonArray.toString();

        System.out.println(jsonString);

        PrintStream out = new PrintStream(toPath);

        out.print(jsonString);
    }
}

class KeyValuePairException extends Exception {
    public KeyValuePairException() {}
    public KeyValuePairException(String message) {
        super(message);
    }
}