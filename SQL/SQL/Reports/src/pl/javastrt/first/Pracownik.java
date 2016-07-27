package pl.javastrt.first;

public class Pracownik {
	
	String imie;
	String nazwisko;
	int wiek;
	
	void ustawImie(String name, String surname, int age){
		imie = name;
		nazwisko = surname;
		wiek = age;
	}
	
	String outImie(){
		return imie;
	}
	String outNazwisko(){
		return nazwisko;
	}
	int outWiek(){
		return wiek;
	}
	
	
	
}
