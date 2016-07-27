package pl.javastrt.first;

import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.RandomAccessFile;

public class binarnie2 {

	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub
		RandomAccessFile rfile = null;
		String sciezka = "test.txt";
		String sciezka2 = "kopia.txt";
		
		int bajty = 0;
		try {
			rfile = new RandomAccessFile(sciezka, "rw");
		} catch (FileNotFoundException e) {
			System.out.println("No file found");
		}

		try {
			rfile.writeUTF("string");
			//rfile.close();
		} catch (IOException e) {
			System.out.println("Blad we wy");
		}
		
		try {
			while(rfile.read() != -1 ){
				bajty++;
				
			}
			
		} catch (IOException e) {
			System.out.println("Blad czytania");
		}
		rfile = new RandomAccessFile(sciezka, "rw");
		try {
			while(rfile.read() != -1 ){
				
				
			}
			
		} catch (IOException e) {
			System.out.println("Blad czytania");
		}

	}

}
