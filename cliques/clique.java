import java.io.*;

public class Clique {

	public static void main(String[] args) {

		Scanner scan = new Scanner(System.in);

		// Ignore the first line of input
		scan.nextLine();

		while (scan.hasNext())
		{
			int numNodes = Integer.parseInt(scan.next());
			int numEdges = Integer.parseInt(scan.next());

			boolean foundMin = false;
			int minLargestCliqueSize = 0;
			for (int r = 1; r < numNodes && !foundMin; r++) {
				if (Clique.turan(numNodes, r) <= numEdges)
					minLargestCliqueSize = r + 1;
				else
					foundMin = true;
			}

			System.out.println(minLargestCliqueSize);
			
		}
	}

	public static double turan(int nodes, int r) {
		return (1.0 - ( 1.0 / r ) )  * ((nodes * nodes) / 2.0 );
	}

}