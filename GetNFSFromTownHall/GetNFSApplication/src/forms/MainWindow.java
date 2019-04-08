package forms;

import objects.NFS;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import javax.naming.LinkException;
import javax.swing.*;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.*;
import java.util.ArrayList;

import static objects.NFS.getNFSObjectFromNode;

public class MainWindow {
    private JPanel rootPanel;
    private JPanel topPanel;
    private JTextField textSelectFile;
    private JButton buttonSelectExcelFile;
    private JTextArea textAreaFileContent;
    private JTextField textInscrMunicipal;

    private String inscMunicipal;
    private String LINE_BREAK = "\n";
    private ArrayList<NFS> arrayListNFS = new ArrayList<>();

    public static void main(String[] args) {
        JFrame frame = new JFrame("MainWindow");
        frame.setContentPane(new MainWindow().rootPanel);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.pack();
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }

    // Class constructor
    private MainWindow() {
        buttonSelectExcelFile.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JFileChooser excelFileChooser = new JFileChooser();
                FileNameExtensionFilter fileFilter = new FileNameExtensionFilter("", "xls", "xlsx", "csv", "txt");

                excelFileChooser.setFileFilter(fileFilter);
                excelFileChooser.setDialogTitle("Selecione um arquivo");
                excelFileChooser.setVisible(true);

                // If user select some file, we'll passing them to another function
                int returnDialogVal = excelFileChooser.showOpenDialog(null);
                if (returnDialogVal == JFileChooser.APPROVE_OPTION) {
                    setSelectedFile(excelFileChooser.getSelectedFile());
                    readFileContent(excelFileChooser.getSelectedFile());
                }
            }
        });
    }

    private void setSelectedFile(File selectedFile) {
        textAreaFileContent.setText("");
        textAreaFileContent.append("Iniciando coleta de notas fiscais no arquivo..." + LINE_BREAK);

        textSelectFile.setText(selectedFile.getAbsolutePath().trim());
        inscMunicipal = textInscrMunicipal.getText().trim();
    }

    private void readFileContent(File selectedFile) {
        String lineToRead;// Try to read each line of file and put into textArea
        try (BufferedReader br = new BufferedReader(new FileReader(selectedFile.getAbsolutePath()))) {
            while ((lineToRead = br.readLine()) != null) {
                NFS currentNFS = getNFSObjectFromNode(lineToRead);
                arrayListNFS.add(currentNFS);
            }
        } catch (IOException | ParserConfigurationException | SAXException | XPathExpressionException e) {
            e.printStackTrace();
        }
        // Finally, after add all content to Array, tell how many records was generated
        textAreaFileContent.append(arrayListNFS.size() + " registros lidos." + LINE_BREAK);
    }

}
