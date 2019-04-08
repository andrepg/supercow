package objects;

public class NFS {
    private String number;
    private String verificationCode;
    private String tomador;
    private String cnpjCpf;
    private String downloadLink;

    public NFS(String nfsNr, String nfsVerification, String nfsTomador, String nfsCnpjCpf, String inscMunicipal) {
        this.number = nfsNr;
        this.verificationCode = nfsVerification;
        this.tomador = nfsTomador;
        this.cnpjCpf = nfsCnpjCpf;
        this.downloadLink = getLinkToDownload(nfsNr, nfsVerification, inscMunicipal);
    }

    private String getLinkToDownload(String nfsNumber, String nfsVerificationCode, String inscMunicipal) {
        String url = "http://www2.goiania.go.gov.br/sistemas/snfse/asp/snfse00200w0.asp?inscricao=%s&nota=%s&verificador=%s";
        return String.format(url, inscMunicipal, nfsNumber, nfsVerificationCode);
    }

    public String getDownloadLink() {
        return downloadLink;
    }
}
