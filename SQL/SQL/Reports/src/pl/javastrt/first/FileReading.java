package pl.javastrt.first;

import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;


public class FileReading {

	public static void main(String[] args) throws FileNotFoundException{
		// TODO Auto-generated method stub
		String text_to_save;
		PrintWriter zapis = new PrintWriter("test.txt");
		Scanner new_txt = new Scanner(System.in);
		text_to_save = new_txt.nextLine();
		
		
		zapis.println(text_to_save);
		
		zapis.close();
		
		
		
		File file = new File("test.txt");
		Scanner ino = new Scanner(file);
		
		//String zdanie = ino.nextLine();
		System.out.println(ino.nextLine());
		
		
		
		
		
		
	}

}
