package pl.javastrt.first;

public class PracownikKonstr {
	String imie;
	String nazwisko;
	int numer;
	
	public PracownikKonstr(){
		imie = "null";
		nazwisko = "null";
		numer = 0;
	}
	
	public PracownikKonstr(String im, String nazw){
		imie = im;
		nazwisko = nazw;
		numer = 1;
	}
	
	public PracownikKonstr(int num){
		imie = "only number";
		nazwisko = "only number nazw";
		numer = num;
	}
	
	
	
}
