package pl.javastrt.first;

public class Tablice {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		int[][] tablica = new int[3][];
		//tablica[0][0] = 6;
		//tablica[0][1] = 7;
		//tablica[0][2] = 8;
		
		tablica[0] = new int[10];
		tablica[1] = new int[2];
		tablica[2] = new int[1];
		
		
		for(int i=0; i< tablica.length; i++){
		    for(int j=0; j< tablica[i].length; j++)
		        System.out.print(tablica[i][j]);
		    System.out.println();
		}
		
		
		
		//System.out.println(tablica[0][0]);
		//System.out.println(tablica[0][1]);
		//System.out.println(tablica[0][2]);
		
		
	}

}
