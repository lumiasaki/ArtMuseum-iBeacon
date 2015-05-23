package com.qunar.fresh.Supermarket.Servlet;

import com.qunar.fresh.Supermarket.DataUtils.DatabaseUtil;
import com.qunar.fresh.Supermarket.Model.Exhibit;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.text.WrappedPlainView;
import java.io.*;

/**
 * Created by Lumia_Saki on 15/5/23.
 */
@WebServlet(name = "ExhibitServlet")
public class ExhibitServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StringBuilder stringBuilder = new StringBuilder();
        BufferedReader bufferedReader = null;
        try {
            InputStream inputStream = request.getInputStream();
            if (inputStream != null) {
                bufferedReader = new BufferedReader(new InputStreamReader(
                        inputStream));
                char[] charBuffer = new char[128];
                int bytesRead = -1;
                while ((bytesRead = bufferedReader.read(charBuffer)) > 0) {
                    stringBuilder.append(charBuffer, 0, bytesRead);
                }
            } else {
                stringBuilder.append("");
            }
        } catch (IOException ex) {
            throw ex;
        } finally {
            if (bufferedReader != null) {
                try {
                    bufferedReader.close();
                } catch (IOException ex) {
                    throw ex;
                }
            }
        }

        Exhibit exhibit = DatabaseUtil.exhibitByMajorValue(Integer.valueOf(stringBuilder.toString()));

        Writer writer = response.getWriter();

        if (exhibit != null) {
            writer.write(exhibit.toString());
        } else {
            writer.write("error");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
