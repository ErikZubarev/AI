Kod, readme och individuell inlämning var skriven av Erik Zubarev : erzu6003

Målet är att en agent ska hitta fiende tankar och röra sig hem så snabbt som möjligt. 

För att testa upfylla målet bör man undersöka många noder genom att röra sig genom fältet. Detta 
sker genom att spelaren styr agenten med piltangenterna. När agenten har hittat en fiende körs A*
algoritmen och hittar den snabbaste vägen hem. Agenten kommer automatiskt följa den snabbaste vägen
hem och vänta i hembasen i 3 sekunder när agenten har kommit fram. För att se snabbaste vägen hem
uppvisad kan spelaren trycka på "d" tangenten för att sätta på "debug mode". "p" tangenten pausar
spelet. 

Agenten kollar 2 noder framför sig, inklusive deras ortogonala grannar. Agenten sätter dessa noder i en 
graf. Varje nod (key) i minnet har en ArrayList (value) som är de ortogonala grannarna. 
När agenten uptäcker en fiende i sin syn så körs en A* algoritm över alla noder i grafen från 
noden agenten står på till målnoden (x: 0, y:0), vilket ligger i agentens bas. 

Spelet är ett grid-baserat spel där varje agent kan röra sig 1 nod åt en av de ortogonala riktningarna.
Spelet är menat att vara turbaserat, alltså att varje agent får sin egen tur att göra vad de vill.
En action counter finns i vänstra hörnet som säger hur många actions agenten har kvar på sin tur.
Eftersom detta är menat att bara funka för 1 agent är alla andra agenter "disabled" och deras tur
kommer skippas. 

Programmet använder standard processing java programmbiblioteket, samt java.util.HashSet och 
java.util.PriorityQueue. 

Programmet är uppbygt i Processing 4 och använder endast tree01_v2.png filen i data mappen. 