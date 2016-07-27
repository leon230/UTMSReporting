package pl.javastrt.first;

/*public class UstawPunkt {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Punkt punkt = new Punkt();
		punkt.wspX = 10;
		punkt.wspY = 20;
		System.out.println("Wsp: (" + punkt.wspX + "," + punkt.wspY + ")");
	}

}*/
public class UstawPunkt{
	public static void main(String args[]){
		Punkt punkt = new Punkt();
		punkt.ustawX(10);
		punkt.ustawY(20);

		System.out.println("Wspó³rzêdne to: ("+ punkt.dajX() + ", "+ punkt.dajY() +")");
	}
}
