package pl.javastrt.first;

public class Firma {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		Pracownik[] pracownicy = new Pracownik[3];
		
		String[] imiona = {"A","B","C"};
		String[] nazwiska = {"N1","N2","N3"};
		int[] lata = {1,2,3};
		
		for (int i = 0; i<pracownicy.length;i++){
			pracownicy[i] = new Pracownik();
			pracownicy[i].ustawImie(imiona[i], nazwiska[i], lata[i]);
			
		}
		
		for (int i = 0; i<pracownicy.length;i++){
			System.out.println(pracownicy[i].outImie() + " " + pracownicy[i].outNazwisko() + " " + pracownicy[i].outWiek());
			
		}
		
		
		
		
		
		
		
		
		
		/*Pracownik prac1 = new Pracownik();
		Pracownik prac2 = new Pracownik();
		
		prac1.ustawImie("Lukasz", "Nazwisko", 30);
		prac2.ustawImie("Lukasz", "Nazwisko2", 60);
		
		System.out.print(prac1.outImie() + " " + prac1.outNazwisko() + " " + prac1.outWiek() + "\n");
		
		System.out.print(prac2.outImie() + " " + prac2.outNazwisko() + " " + prac2.outWiek());*/
		
	}

}
