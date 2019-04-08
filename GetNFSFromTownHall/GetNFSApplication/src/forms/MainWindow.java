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

public class MainWindow {
    private JPanel rootPanel;
    private JPanel topPanel;
    private JTextField textSelectFile;
    private JButton buttonSelectExcelFile;
    private JTextArea textAreaFileContent;
    private JTextField textInscrMunicipal;

    private String inscMunicipal;
    private String LINE_BREAK = "\n";
    private File fileToRead;

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
                }
            }
        });
    }

    private void setSelectedFile(File selectedFile) {
        textAreaFileContent.setText("");
        textSelectFile.setText(selectedFile.getAbsolutePath().trim());
        inscMunicipal = textInscrMunicipal.getText().trim();
        readFileContent(selectedFile);
    }

    private void readFileContent(File selectedFile) {
        String xPathNfsNumber = "/GerarNfseResposta/ListaNfse/CompNfse/Nfse/InfNfse/Numero";
        String xPathNfsVerificationCode = "/GerarNfseResposta/ListaNfse/CompNfse/Nfse/InfNfse/CodigoVerificacao";
        String xPathNfsRazaoTomador = "/GerarNfseResposta/ListaNfse/CompNfse/Nfse/InfNfse/DeclaracaoPrestacaoServico/InfDeclaracaoPrestacaoServico/Tomador/RazaoSocial";
        String xPathNfsCpf = "/GerarNfseResposta/ListaNfse/CompNfse/Nfse/InfNfse/DeclaracaoPrestacaoServico/InfDeclaracaoPrestacaoServico/Tomador/IdentificacaoTomador/CpfCnpj/Cpf";
        String xPathNfsCnpj = "/GerarNfseResposta/ListaNfse/CompNfse/Nfse/InfNfse/DeclaracaoPrestacaoServico/InfDeclaracaoPrestacaoServico/Tomador/IdentificacaoTomador/CpfCnpj/Cnpj";

        String lineToRead;// Try to read each line of file and put into textArea
        try (BufferedReader br = new BufferedReader(new FileReader(selectedFile.getAbsolutePath()))) {
            DocumentBuilder dBuilder = (DocumentBuilderFactory.newInstance()).newDocumentBuilder();
            InputSource inputSource = new InputSource();

            XPathFactory factory = XPathFactory.newInstance();
            XPath xpath = factory.newXPath();

            while ((lineToRead = br.readLine()) != null) {
                inputSource.setCharacterStream(new StringReader(lineToRead));
                Node node = (dBuilder.parse(inputSource)).getDocumentElement().getFirstChild();

                String nfsNumber = (xpath.evaluate(xPathNfsNumber, node).trim());
                String nfsVerificationCode = (xpath.evaluate(xPathNfsVerificationCode, node).trim());
                String nfsTomador = (xpath.evaluate(xPathNfsRazaoTomador, node).trim());

                String nfsCPF = (xpath.evaluate(xPathNfsCpf, node).trim());
                String nfsCNPJ = (xpath.evaluate(xPathNfsCnpj, node).trim());

                NFS currentNFS = new NFS(
                        nfsNumber,
                        nfsVerificationCode,
                        nfsTomador,
                        (nfsCPF.equals("") ? nfsCNPJ : nfsCPF),
                        inscMunicipal);

                textAreaFileContent.append(currentNFS.getDownloadLink() + LINE_BREAK);
            }
        } catch (IOException | ParserConfigurationException | SAXException | XPathExpressionException e) {
            e.printStackTrace();
        }
    }

}
