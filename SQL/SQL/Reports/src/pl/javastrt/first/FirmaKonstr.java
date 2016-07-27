package pl.javastrt.first;

public class FirmaKonstr {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		PracownikKonstr[] pracownicy = new PracownikKonstr[3];
		
		pracownicy[0] = new PracownikKonstr();
		pracownicy[1] = new PracownikKonstr("Luke","Skywalker");
		pracownicy[2] = new PracownikKonstr(1001);
		
		for(PracownikKonstr p: pracownicy)
			System.out.println(p.imie + " " + p.nazwisko + " " + p.numer);
	}

}
