import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.HashMap;
import weka.core.Attribute;
import weka.core.FastVector;
import weka.core.Instance;
import weka.core.Instances;

public class Generate_arff {
	
	public static void main(String args[])throws IOException
	{
		FileInputStream f;
		DataInputStream in;	
		BufferedReader b;
		File fout;
		FileWriter o;
		PrintWriter p;
		int count = 0;
		int z = 0;
		
//----------------Extracting the shadow pixel values from the xml datset-----------------
		
		while(z<62)
		{
			z++;
			f = new FileInputStream("data/actual/"+z+".xml");
			in = new DataInputStream(f);	
			b = new BufferedReader(new InputStreamReader(in));
			fout = new File("output/"+z+".txt");
			o = new FileWriter(fout);
			p = new PrintWriter(o);

			count = 0;
			
			while(true)   
			{	
				String read = new String();
				if((read = b.readLine())==null)
					break;
				count++;
						
				if(read.equalsIgnoreCase("</shadowCoords>"))
					break;
				if(count>2)
				{
					for(int i=0;i<read.length();i++)
					{
						String write = new String();
						if(read.charAt(i)=='"')
						{
							i++;
							while(read.charAt(i)!='"')
							{
								write+=read.charAt(i++);
							}
							p.println(write);
						}
					}
				}
			}
			System.out.println(z+"lines: "+count);
			f.close();
			in.close();
			o.close();
			b.close();
			p.flush();
		}	

//-------------------------------Generating arff file---------------------------------
		
		FastVector attr;
		Instances data;
		double val[];
		attr=new FastVector();

		//------assigning 36 features as numeric attributes---------
		for(int i=1 ; i<=36 ; i++)
		{
			Attribute inside=new Attribute("a"+i);
			attr.addElement(inside);
		}
		//----------------------------------------------------------
		
		//--------assigning shadow and non-shadow class-------------
		FastVector last_type=new FastVector(2);
		last_type.addElement(""+0);
		last_type.addElement(""+1);
		Attribute last=new Attribute("pix_class",last_type);
		attr.addElement(last);
		//----------------------------------------------------------
		
//------------------------------ generating Training arff--------------------------------
		
		data= new Instances("train", attr, 0);
		data.setClass(last);
		File train = new File("arff/train.arff");
		FileWriter out = new FileWriter(train);
		PrintWriter pr = new PrintWriter(out);
		
		int mc=0;
		while (mc<42)
		{
			mc++;
			System.out.println("Reading File: "+mc);
			f = new FileInputStream("data/calculated/"+mc+".txt");
			in = new DataInputStream(f);	
			b = new BufferedReader(new InputStreamReader(in));
			String s = b.readLine();
			String[] input  = s.split(" ");
			double cal[] = new double[input.length];
				
			for(int i=0;i<input.length;i++)
				cal[i] = Double.parseDouble(input[i]);
		
			f.close();
			in.close();
			b.close();
		
			double r1;double r2;
			double s1;double s2;
			int i=36;int za=0;int z1=0;
			
			HashMap<String,Double> compare = new HashMap<String,Double>();
			f= new FileInputStream("output/"+mc+".txt");
			in= new DataInputStream(f);	
			b= new BufferedReader(new InputStreamReader(in));
			
			while(true)
			{
					String a1 = new String ();
					String a2 = new String ();
					String a = new String();
					
					if((a1 = b.readLine())==null)
						break;
					if((a2 = b.readLine())==null)
						break;
					
					r1 = Double.parseDouble(a1);
					r2 = Double.parseDouble(a2);
					s1 = (r1+0.5);
					s2 = (r2+0.5);
					
					a=s2+" "+s1;
								
					if(compare.containsKey(a))
					{
						compare.put(a,(compare.get(a).doubleValue() + 1));
					}
					else
						compare.put(a,(double) 1);
			}
			f.close();in.close();b.close();
			
			while(i<cal.length)
			{
				za++;
				val=new double[data.numAttributes()];
				int n=0;
				int shadow = 0;
				String y = new String();
				y=cal[i]+" "+cal[i+1];
				
				if(compare.containsKey(y))
				{
					z1++;
					shadow = 1;
				}
				
				while(n<36)
				{
					val[n] = cal[i-36+n];
					n++;
				}
				val[data.numAttributes()-1]=shadow;
				data.add(new Instance(1.0,val));
				i+=38;	
			}
			System.out.println("File: " +mc+" | za: "+za+" | i: "+i+" | z1: "+z1);
		}
		pr.println(data);
		pr.flush();
		out.close();
		
//--------------------------------Generating Testing arff----------------------------

		data= new Instances("test", attr, 0);
		data.setClass(last);
		
		File test = new File("arff/test.arff");
		FileWriter out1 = new FileWriter(test);
		PrintWriter pr1 = new PrintWriter(out1);
		
		while (mc<62)
		{
			mc++;
			System.out.println("Reading File: "+mc);
			f = new FileInputStream("data/calculated/"+mc+".txt");
			in = new DataInputStream(f);	
			b = new BufferedReader(new InputStreamReader(in));
			String s = b.readLine();
			String[] input  = s.split(" ");
			double cal[] = new double[input.length];
				
			for(int i=0;i<input.length;i++)
				cal[i] = Double.parseDouble(input[i]);
		
			f.close();
			in.close();
			b.close();
		
			double r1;double r2;
			double s1;double s2;
			int i=36;
			int za=0;int z1=0;
			
			HashMap<String,Double> compare = new HashMap<String,Double>();
			f= new FileInputStream("output/"+mc+".txt");
			in= new DataInputStream(f);	
			b= new BufferedReader(new InputStreamReader(in));
			
			while(true)
			{
					String a1 = new String ();
					String a2 = new String ();
					String a = new String();
					
					if((a1 = b.readLine())==null)
						break;
					if((a2 = b.readLine())==null)
						break;
					
					r1 = Double.parseDouble(a1);
					r2 = Double.parseDouble(a2);
					s1 = (r1+0.5);
					s2 = (r2+0.5);
					
					a=s2+" "+s1;
								
					if(compare.containsKey(a))
					{
						compare.put(a,(compare.get(a).doubleValue() + 1));
					}
					else
						compare.put(a,(double) 1);
			}
			f.close();in.close();b.close();
			
			while(i<cal.length)
			{
				za++;
				val=new double[data.numAttributes()];
				int n=0;
				int shadow = 0;
				String y = new String();
				y=cal[i]+" "+cal[i+1];
				
				if(compare.containsKey(y))
				{
					z1++;
					shadow = 1;
				}
				
				while(n<36)
				{
					val[n] = cal[i-36+n];
					n++;
				}
				val[data.numAttributes()-1]=shadow;
				data.add(new Instance(1.0,val));
				i+=38;	
			}
			System.out.println("File: " +mc+" | za: "+za+" | i: "+i+" | z1: "+z1);
		}
		pr1.println(data);
		pr1.flush();
		out1.close();
	}	

}
