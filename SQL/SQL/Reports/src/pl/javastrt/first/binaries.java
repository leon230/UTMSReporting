package pl.javastrt.first;

import java.util.Date;
import java.io.DataOutputStream;
import java.io.DataInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.io.FileOutputStream;
import java.io.FileInputStream;




public class binaries {

	public static void main(String[] args) throws IOException {	
		// TODO Auto-generated method stub
		
		String name = "Lukas";
		Date data = new Date();
		Double wynik = (double)50/(double)4;
		
		String dozapisu = name + " " + data.toString() + " " + wynik.toString();
		
		String sciezka = "test.txt";
		//DataOutputStream wej = null;
		try{
			DataOutputStream wej = new DataOutputStream(new FileOutputStream(sciezka));
		
			wej.writeUTF("testowy");
			
			wej.close();
			
		} catch(FileNotFoundException e){
			System.out.println("No file or Dir");
		}
		
		
		
		
		System.out.println(dozapisu);
		
		
		
		
		
		
		
		
	}

}
