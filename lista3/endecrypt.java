import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.security.AlgorithmParameters;
import java.security.Key;
import java.security.KeyStore;
import java.util.Scanner;

import org.apache.commons.io.FilenameUtils;

import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.IvParameterSpec;
import javax.swing.JFileChooser;

public class endecrypt {
	/*key1, keystorepass, keypass*/
	static String encrypt(String alg, String mode, String path, String keyId, String keyPass, String filepath, String filename) throws Exception {
		String transformation = "";
		switch(alg.toUpperCase()) {
			case "AES":
				transformation = transformation.concat("AES"); break;
			default:
				return "Algorithm not implemented";	
		}
		switch(mode.toUpperCase()){
			case "CBC":
				transformation = transformation.concat("/CBC"); break;
			case "CTR":
				transformation = transformation.concat("/CTR"); break;
			case "GCM":
				transformation = transformation.concat("/GCM"); break;
			default:
				return "Mode not implemented";
		}
		transformation = transformation.concat("/PKCS5Padding");
		System.out.println(transformation);
		
		// wyciaganie klucza z keystora
		InputStream keystoreStream = new FileInputStream(path);
		KeyStore keystore = KeyStore.getInstance("JCEKS");
		keystore.load(keystoreStream, "keystorepass".toCharArray());
		if (!keystore.containsAlias(keyId)) {
		    throw new RuntimeException("Alias for key not found");
		}
		Key key = keystore.getKey(keyId, keyPass.toCharArray());
		
		Cipher cipher = Cipher.getInstance(transformation);
		cipher.init(Cipher.ENCRYPT_MODE, key);
		AlgorithmParameters params = cipher.getParameters();
		byte[] iv;
		if(mode.toUpperCase().equals("GCM")) {		
			iv = params.getParameterSpec(GCMParameterSpec.class).getIV();
			cipher.updateAAD("auth".getBytes());
			System.out.println("getTLen"+params.getParameterSpec(GCMParameterSpec.class).getTLen());
			//System.out.println(params.getParameterSpec(GCMParameterSpec.class));
		} else {
			iv = params.getParameterSpec(IvParameterSpec.class).getIV();
		}
		
		Path path1 = Paths.get(filepath + "\\" + filename);
		byte[] ciphertext = cipher.doFinal(Files.readAllBytes(path1));
		byte[] ciphfinal;
		ciphfinal = new byte[iv.length + ciphertext.length];
		System.arraycopy(iv, 0, ciphfinal, 0, iv.length);
		System.arraycopy(ciphertext, 0, ciphfinal, iv.length, ciphertext.length);
		//System.out.println("iv.length: "+iv.length);
	
		//System.out.println(ciphfinal.length);
		FileOutputStream fos = new FileOutputStream(
				filepath +"\\"+ filename // sciezka\plik.txt
				+"."+alg.toUpperCase()+"_"+mode.toUpperCase()+"_encrypted");			// .AES_CBC_encrypted
		fos.write(ciphfinal);
		fos.close();
		return "File encrypted";
	}
	
	static String decrypt(String alg, String mode, String path, String keyId, String keyPass, String filepath, String filename) throws Exception {
		String transformation = "";
		switch(alg.toUpperCase()) {
			case "AES":
				transformation = transformation.concat("AES"); break;
			default:
				return "Algorithm not implemented";	
		}
		switch(mode.toUpperCase()){
			case "CBC":
				transformation = transformation.concat("/CBC"); break;
			case "CTR":
				transformation = transformation.concat("/CTR"); break;
			case "GCM":
				transformation = transformation.concat("/GCM"); break;
			default:
				return "Mode not implemented";
		}
		transformation = transformation.concat("/NoPadding");
		System.out.println(transformation);
		
		// wyciaganie klucza z keystora
		InputStream keystoreStream = new FileInputStream(path);
		KeyStore keystore = KeyStore.getInstance("JCEKS");
		keystore.load(keystoreStream, "keystorepass".toCharArray());
		if (!keystore.containsAlias(keyId)) {
		    throw new RuntimeException("Alias for key not found");
		}
		Key key = keystore.getKey(keyId, keyPass.toCharArray());
		
		Path path1 = Paths.get(filepath + "\\" + filename);
		byte[] fileBytes = Files.readAllBytes(path1);
		//System.out.println(fileBytes.length);
		
		
		Cipher cipher = Cipher.getInstance(transformation);
		
		byte[] ivBytes, cipherBytes;
		if(mode.toUpperCase().equals("GCM")) {
			ivBytes = new byte[12];
			System.arraycopy(fileBytes, 0, ivBytes, 0, 12);
			cipherBytes = new byte[fileBytes.length - 12];
			System.arraycopy(fileBytes, 12, cipherBytes, 0, fileBytes.length-12);
			cipher.init(Cipher.DECRYPT_MODE, key, new GCMParameterSpec(128, ivBytes));
			cipher.updateAAD("auth".getBytes());
		} else {
			ivBytes = new byte[16];
			System.arraycopy(fileBytes, 0, ivBytes, 0, 16);
			cipherBytes = new byte[fileBytes.length - 16];
			System.arraycopy(fileBytes, 16, cipherBytes, 0, fileBytes.length-16);
			cipher.init(Cipher.DECRYPT_MODE, key, new IvParameterSpec(ivBytes));
		}
		
		byte[] result = cipher.doFinal(cipherBytes);
		
		FileOutputStream fos = new FileOutputStream(
				filepath+"\\"+FilenameUtils.removeExtension(FilenameUtils.removeExtension(filename))
				+"_"+alg.toUpperCase()+"_"+mode.toUpperCase()+"_decrypted"
				+"."+FilenameUtils.getExtension(FilenameUtils.removeExtension(filename)));
		fos.write(result);
		fos.close();
		return "File decrypted";
	}
	
	public static void main(String[] args) throws Exception {
		String schemat, tryb, keystorePath, keyId, pass;
		System.out.print("Podaj algorytm: ");
		Scanner sc = new Scanner(System.in);
		schemat = sc.nextLine();
		if(schemat.equals(""))
			schemat = "AES";
		System.out.println("Wybrany algorytm: "+schemat);
		
		System.out.print("Podaj tryb: ");
		tryb = sc.nextLine();
		if(tryb.equals(""))
			tryb = "CTR";
		System.out.println("Wybrany tryb: "+tryb);
		
		System.out.println("podaj sciezke do keystore'a: ");
		
		keystorePath = sc.nextLine();
		if(keystorePath.equals(""))
			keystorePath = "d:\\stuff\\keystore.jks";
		System.out.println("sciezka: "+ keystorePath);
		
		System.out.print("Podaj identyfikator klucza: ");
		keyId = sc.nextLine();
		if(keyId.equals(""))
			keyId = "key1";
		System.out.println("Wybrany identyfikator klucza: "+keyId);
		
		System.out.print("Podaj haslo do klucza: ");
		//char[] passCh = System.console().readPassword();
		//pass = passCh.toString();
		pass = "keypass";
		System.out.println("Haslo wczytane.");
		
		System.out.println("Podaj sciezke do folderu z plikiem: ");
		Scanner in = new Scanner(System.in);
		String filepath = in.nextLine();
		if(filepath.equals(""))
			filepath = "d:\\stuff";
		System.out.println("Podana sciezka: "+ filepath);
		System.out.println("Podaj nazwe pliku: ");
		String filename = in.nextLine();
		if(filename.equals(""))
			filename = "pliczek.txt";
		System.out.println("Wybrana nazwa pliku: "+ filename);
		
		System.out.print("Wybierz szyfrowanie (\"e\") lub deszyfrowanie (\"d\"): ");
        
        String str = in.next();
        if(str.equals("e"))
        	System.out.println(encrypt(schemat, tryb, keystorePath, keyId, pass, filepath, filename));
        else if(str.equals("d"))
        	System.out.println(decrypt(schemat, tryb, keystorePath, keyId, pass, filepath, filename));
        else
        	System.out.println("Brak podanej opcji");
		
		
       
	}

}
