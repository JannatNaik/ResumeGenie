package your.package;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.Files;

@WebServlet("/UploadResumeServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1,  // 1MB
        maxFileSize = 1024 * 1024 * 10,               // 10MB
        maxRequestSize = 1024 * 1024 * 15)            // 15MB
public class UploadResumeServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("uid") == null || session.getAttribute("profileId") == null) {
            response.sendRedirect("Signin.jsp");
            return;
        }

        int uid = (int) session.getAttribute("uid");
        int profileId = (int) session.getAttribute("profileId");

        Part filePart = request.getPart("resume");
        String fileName = getFileName(filePart);
        String extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();

        if (!extension.equals("pdf") && !extension.equals("docx") && !extension.equals("doc")) {
            response.getWriter().println("Unsupported file type.");
            return;
        }

        // Save file to a temp directory
        File uploads = new File(System.getProperty("java.io.tmpdir"));
        File uploadedFile = new File(uploads, fileName);
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, uploadedFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
        }

        // Full path to your Python script
        String pythonScriptPath = "/absolute/path/to/applicant_flow.py";

        try {
            // Correct argument order: file_path, uid, profile_id
            ProcessBuilder pb = new ProcessBuilder(
                    "python3",
                    pythonScriptPath,
                    uploadedFile.getAbsolutePath(),
                    String.valueOf(uid),
                    String.valueOf(profileId)
            );

            pb.redirectErrorStream(true);
            Process process = pb.start();

            // Optional: Read and print Python output
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println("[PYTHON] " + line);
            }

            int exitCode = process.waitFor();
            System.out.println("Python script exited with code: " + exitCode);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error processing resume.");
            return;
        }

        response.sendRedirect("UserProfile.jsp"); // Redirect to profile or confirmation page
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return "resume";
    }
}
