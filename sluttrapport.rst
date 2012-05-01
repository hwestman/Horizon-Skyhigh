=====================
Bacheloroppgave
=====================

.. figure:: forsideboks.png
   :scale: 50 %

   Figur 1: Forsideboks

|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|
|

:Forfattere:
  Lars Erik Pedersen, Jon Arne Westgaard, Hallvard Westman

:Versjon: 0.5 - 18.04.2012
:Dedikert til: Mamma


.. ``twelvepoint``

.. header:: SkyHigh Adm
.. footer:: ###Page###



.. Overskrift1 = #
.. Overskrift2 = -
.. Overskrift3 = *
.. Overskrift4 = .


.. raw:: pdf

  PageBreak


.. csv-table:: Tabell 1: Sammendrag av bacheloroppgave
   :widths: 15,50  

   "**Tittel:**", "SkyHiGh Adm      **Nr: - Dato: 24.05.12**"
   "**Deltaker(e)**", "Lars Erik Pedersen, Jon Arne Westgaard, Hallvard Westman"
   "**Veileder(e):**", "Hanno Langweg, Høgskolen i Gjøvik"
   "**Oppdragsgiver:**", "Erik Hjelmås, Høgskolen i Gjøvik"
   "**Kontaktperson:**", ""
   "**Stikkord (4stk):**", "sky, virtualisering, pupp"
   "**Antall Sider:**", "**Antall bilag:** **Tilgjengelighet (åpen/konfidensiell):** Åpen"
   "**Kort beskrivelse av bacheloroppgaven:**", "Sette opp en skalerbar sky-tjeneste til bruk i undervisning på HiG"

Se vedlegg M. Ekstra forside? Skriv et godt sammendrag så det kan presenteres.



   
.. raw:: pdf

  PageBreak


.. csv-table:: Tabell 2: Summary of Graduate Project
  :widths: 15,50  

   "**Title:**", "SkyHiGh Adm      **Nr: - Dato: 24.05.12**"
   "**Participants**", "Lars Erik Pedersen, Jon Arne Westgaard, Hallvard Westman"
   "**Supervisor:**", "Hanno Langweg, Høgskolen i Gjøvik"
   "**Employer:**", "Erik Hjelmås, Høgskolen i Gjøvik"
   "**Contact person:**", ""
   "**Keywords:**", "sky, virtualisering, pupp"
   "**Pages:**", "**Antall bilag:** **Tilgjengelighet (åpen/konfidensiell):** Åpen"
   "**Short description of the main project:**", "Sette opp en skalerbar sky-tjeneste til bruk i undervisning på HiG"


.. raw:: pdf

  PageBreak

Forord
#######



Oppdragsgiver er Erik Hjelmås, førsteamenuensis ved Høgskolen i Gjøvik. Erik underviser i Operativsystemer og Systemadministrasjon, hvor han benytter virtuelle maskiner i undervisningen.

Takk til uksysadmin, mjfork, kiall (OpenStack utviklere), samt resten av de hjelpsomme sjelene på #openstack for support over IRC. Deres kunnskap og hjelpsomhet har bidratt i stor grad til å drive prosjektet fremover.

*Underskrift fra alle gruppemedlemmer, samt sted og dato.*

::

  Nå drar vi på McDonalds.



.. contents:: Innholdsfortegnelse

.. sectnum::


.. raw:: pdf
   
  PageBreak

Innledning
###########

| En "nettsky" (Cloud-computing) er levering av databehandling som en tjeneste snarere enn et produkt, der delte ressurser, programvare og informasjon er gitt til datamasiner og andre enheter som et verkøty over nettverket (internett).
| Cloud Computing (nettverkssky) er definert som tilgangen til datamaskiner og deres funksjonalitet via internett, eller et lokalt nettverk. Brukerene av en slik nettverkssky får tradisjonelt tilgang til disse tjenestene via en webtjeneste, enten via en tradisjonell PC eller en mobil applikasjon. Grunnen til at det kalles en nettsky, er at tjenestens fysiske lokasjon er usynlig for brukeren, og også ofte for de som leverer nettskyen. Det skal ikke være mulig for tjenesteleverandøren å peke ut at bruker X's data ligger på server Y. Selve skyen er rent teknisk et sett maskiner og webtjenester som har implementert cloud computing som tjeneste,
|
| I en verden i en stadig framgang har nettskyen gjort sitt inntog for mannen i gata, kanskje nesten uten at man tenker opver det selv. "Alt" lagres i skyen; e-post, kontakter, bokmerker, kalendere, dokumenter, bilder m.m. Innholdet er alltid synkronisert mellom mobiltelefonen, laptopen, kontor-PC'en og nettbrettet.
| Tilgjengelighet har blitt alfa og omega, og nå skal også fysiske maskiner inn i skyen i form av virtuelle maskiner. Slike løsninger gjør hverdagen mer effektiv, og vil forekle lab-arbeid i forbindelse med studier av datasystemer. Ufordringene ligger i ytelse, konfigurasjon og skalerbarhet.

(Wikipedia er nok brukt som kilde her, få med url...)


Organisering av rapporten
--------------------------

.. role:: rubric

:rubric:`og kort beskrivelse av sammenhengen mellom kapitlene`


Prosjektrapporten er delt inn i **9** forskjellige kapitler:

#) Innledning_ - dette kapitlet omhandler bakgrunn, formål, 

#) `Analyse/Diskusjon`_ - Vi skal være kritiske!

#) Kravspesifikasjon_ - hele kravspesifikasjonen for prosjektet

#) Teori_ - Generell teori om OpenStack-arkitekturen og lignende

#) Design_ - Løsning av use-cases

#) Gjennomføring_ - Hvordan vi har gjennomført prosjektet

#) Konklusjon_ - Oppsummering, evaluering

#) Underskrift_ - Navnene våre, skrevet med blå penn

#) `Litteraturliste og referanser`_ - It's kinda in the name

#) Vedlegg_ - Figurer, tabeller, backlog, arbeids-og møtelogg, grupperegler og kildekode


Fullstendig definering -  Oppgavedefinisjon/oppgavebeskrivelse
---------------------------------------------------------------

.. role:: rubric

:rubric:`av oppgaven med utdypning av hva oppgaven går ut på.
Henvisning til eventuelle tidligere arbeider om samme emne.
Skal ikke inneholde noe om det som er gjort i oppgaven og oppnådde resultater`


Nettskyer har fått mye oppmerksomhet de siste årene, og er en teknologi som gjør det mulig for sluttbrukere å kjøre virtuelle maskiner på andres maskinvare og infrastruktur. Dette åpner for muligheter for dynamisk skalering av ressurser, fleksibilitet og økonomiske besparelser.

Slike skyer kan man dra nytte av i undervisning hvor man da kan bruke disse til forskning eller som lab til studenter. I emnene Ethical Hacking And Penetration Testing, Systemadministrasjon og Database- og applikasjonsdrift har virtuelle maskiner vært brukt en stund, hvor elevene får utdelt ett sett med virtuelle maskiner som man da kan kjøre tester og gjøre oppgaver på. På denne måten får man dratt nytte av praktisk undervisning uten å måtte sette opp fysiske maskiner. Skulle man komme i skade for å kjøre en kommando eller gjøre en endring som ødelegger konfigurasjonen, skal det bare et par tastetrykk til for å gjenopprette opprinnelig konfigurasjon.
Dagens løsning er basert på MLN(ref!), men er litt kompleks på administrasjons-siden samt har vist ytelsesproblemer. All administrasjon må gjøres av en administrator, og når en hel klasse bruker de virtuelle maskinene samtidig går mye av tiden til å vente på at kommandoer skal kjøres og at de virtuelle maskinene skal "reagere".
Per dags dato er det ikke mulighet for at studenter/faglig ansatte, på en lettvint måte, kan opprette og administrere en eller flere virtuelle maskiner. 

Navnet SkyHiGh spiller på "sky" og "HiG", og er prosjektet for HiG sin nettsky. Formålet er å få satt opp et system hvor studenter og faglig ansatte kan opprette virtuelle maskiner via en selvbetjenings-løsning uten at en administrator må opprette virtuelle maskiner manuelt til de som behøver dette, samt muligheten for fremtidig skalering av infrastrukturen dette kjører på hvis/når dette blir nødvendig.

Slik vil arbeidsbelastningen på administrator minskes, og forelesere vil kunne få full kontroll over de virtuelle maskiner som brukes i undervisningen.



Formål/hvorfor dette emnet
---------------------------
Vi er alle 3 aktive brukere av skytjenesten til Amazon (EC2), en tjeneste vi forsåvidt er fornøyd med. Utfordringene med å sette opp en privat og open-source skytjeneste virket spennende for oss, som også ville gi oss gode erfaringer å ta med oss nå som skytjenester er i vinden. 

             
--------------

.. role:: rubric

:rubric:`for rapporten og oppgaven`

SkyHiGh-prosjektet er startet av Erik Hjelmås fra IMT-avdelingen ved Høgskolen i Gjøvik. Prosjektets formål er å tilby forelesere på IMT en enkel måte å opprette og administrere en samling av virtuelle maskiner til bruk i undervisningen, samt mulighet for at enkeltpersoner som har bruk for en virtuell maskin skal kunne opprette og administrere denne selv.

I første omgang vil målgruppen for prosjektet og rapporten være forelesere (og studenter) ved IMT, som har erfaring med bruk av virtuelle maskiner.

Problemområde
--------------

Litt usikker på ka som skal være her, så sett opp ei fin liste:

  - Sette opp en fungerende løsning med OpenStack
  - Løse ytelsesproblemer
  - Løse skaleringsutfordringer
  - Tilpasse OpenStack til prosjektets formål


Omfang
-------

Omfang - kan være ganske stort. (Trenger vi egentlig dette?)

Avgrensing
-----------

*Hentet fra kravspesifikasjonen*
Prosjektet skal først og fremst implementere OpenStack-rammeverket for å virkeliggjøre målene nevnt i 1.2(???). Å bygge en privat skyløsning er et prosjekt som vanligvis spenner over en mye lengre tidsperiode enn vi har til rådighet. Derfor vil vi ikke drive ytelsestesting og analyse (da dette dekkes av en annen bacheloroppgave). Mulighetene for “high availability” og redundans skal ikke dekkes. Primært skal systemet utvikles for å bli brukt på HiG, for de aktuelle emnene, ikke for eksterne brukere. Allikevel bør det være enkelt å utvide det i den retningen.

Studentenes faglige bakgrunn
-----------------------------

.. role:: rubric

:rubric:`- Egen bakgrunn og kompetanse. Hva må læres?    - Python, Django, OpenStack`


| Gruppemedlemmene kommer fra to forskjellige studieretninger, Jon Arne og Lars Erik studerer Drift av Nettverk og Datasystemer og Hallvard studerer Programvareutvikling. Hallvard har kunnskapen som trengs innenfor programmering og utvikling, Jon Arne og Lars Erik stiller med kompetanse innenfor nettverk. Vi har alle gode kunnskaper innen linux, samt C++ og Java fra programmeringsfag ved Høgskolen i Gjøvik. I tillegg kan Hallvard sjonglere. 
|
|
| Ingen av oss har erfaring med OpenStack, så her får vi litt å sette oss inn i.
| Python er et programmeringsspråk vi har hørt om, men ikke programmert noe i. Siden OpenStack er skrevet i Python kreves det at vi lærer oss dette.
|
| Vi har kjøpt inn en bok om Python-programmering.

Øvrige roller
--------------


Oppdragsgiver er Erik Hjelmås, Førsteamanuensis ved Høgskolen i Gjøvik.

Veileder er Hanno Langweg, Førsteamanuensis ved Høgskolen i Gjøvik.


Arbeidsformer
--------------

.. role:: rubric

:rubric:`samtaler og intervjuer med kilder, reiser, bedriftsbesøk, litteraturstudier, laboratorieforsøk, modellbygging og testing`

Siden ingen av oss har noen erfaring med OpenStack kreves det at vi setter oss godt inn i OpenStack ved prosjektets begynnelse. Dokumentasjonen på http://openstack.org kommer godt med her, i tillegg til å søke etter brukserfaringer på internett. Vi har hatt løpende kontakt med utviklerene av OpenStack vi IRC(ref) på kanalen #openstack og #horizon-dev.

Siden OpenStack er er forholdsvis nytt prosjekt er erfaringene og dokumentasjonen litt mangelfull, så prøv-og-feil-metoden blir hyppig brukt. Etter installasjonen av operativsystemet på serverene vi skal bruke tok vi et disk-image som vi kan rulle tilbake til hvis vi støter på problemer ved installering av OpenStack, slik at vi ikke trenger å installere hele operativsystemet på nytt.




Terminologibruk
----------------

*Er eksempelvis faguttrykk brukt i en spesiell betydning*

Liste over terminologier:

  - **Hypervisor:** In computing, a hypervisor, also called virtual machine manager (VMM), is one of many hardware virtualization techniques allowing multiple operating systems, termed guests, to run concurrently on a host computer. It is so named because it is conceptually one level higher than a supervisory program. The hypervisor presents to the guest operating systems a virtual operating platform and manages the execution of the guest operating systems. Multiple instances of a variety of operating systems may share the virtualized hardware resources. Hypervisors are installed on server hardwarewhose only task is to run guest operating systems. (Wikipedia)
  - **VM/virtuell maskin:** En simulert versjon av et operativsystem
  - **Instans:** Image + flavor
  - **Flavor:** Et sett med virtuell maskinvarekonfigurasjon. Antall virtuelle prosessorer, mengde RAM, lagringsplass
  - **Image:** En diskfil med en ferdig installert virtuell maskin
  - **Prosjekt:** Samling av virtuelle maskiner. Et prosjekt har en kvote tilknyttet seg.
  - **Tenant:** Et prosjekt (OpenStack-terminlogi)
  - **IP-pool:** En rekke IP-adresser
  - **MVC:** Model view controller, et pattern for å skille logikk,data og presentasjon.

Problemområde, avgrensing og oppgavedefinisjon
-----------------------------------------------

.. role:: rubric

:rubric:`Formål/hvorfor dette emnet, Rammer (Gjennomføring og arbeidsmetoder, prosjektorganisering og fremdriftsplan), Øvrige roller (Oppdragsgiver, veileder), Selve rapporten (Organisering, terminologi (bruk norsk), praktisk (angående layout, style, fonter o.l.)`



Rammer (gjennomføring og arbeidsmetoder, prosjektorganisering og fremdriftsplan)
---------------------------------------------------------------------------------


Analyse/Diskusjon
##################


Vi skal være kritiske!

  - Openstack: Modent nok?
    
    - "You can't run OpenStack if you're not doing heavy development at the same time"

  - Skytjenester: Utfordringer med tanke på sikkerhet osv.
  - 
  -
  -
  -
  -



.. raw:: pdf

  PageBreak


Kravspesifikasjon
##################

Prosjektbeskrivelse
--------------------

Kravspesifikasjonen er kun ment å dekke utviklingsdelen av dette prosjektet. Oppsett, installering og implementasjon dekkes i egne kapitler REFERANSE, da dette ikke er emner som skal kravspesifiseres på samme måte som en utviklingsprosess. Da kravspesifikasjonen ble skrevet før utviklingsperioden staret, reflekterer den ikke nødvendigvis hva som faktisk ble implementert.

Funksjonaliteten som allerede eksisterer i MLN, skal ivaretas og videreføres til det nye systemet i form av et webgrensesnitt. OpenStack har etter tidligere undersøkelser (se forprosjekt) REFERANSE blitt valgt som plattform, og dets webgrensesnitt skal modifiseres og videreutvikles til å tilfredstille kravene fra MLN og nye krav fra arbeidsgiver. 

Funksjonelle krav
------------------

Siden dette prosjektet er en portering av en eksisterende løsning, og i så måte ikke er et tradisjonelt utviklingsprosjekt, må vi se på eksisterende funksjonalitet for å se om den  tilfredsstilles i den nye løsningen. Tabellen nedenfor reflekterer hvilke funksjonalitet som finnes i dagens løsning, og hvorvidt det må gjøres utvikling for at det skal fungere på samme måte i OpenStack. En forutsetning for at porteringen skal kunne sees på som gjennomførbar og suksessfull, vil være at all eksisterende funksjonalitet enten må være tilfredsstilt av OpenStacks webgrensesnitt, eller at det lar seg gjøre å utvikle de manglene som finnes.


Rammer og funksjonalitet som er tilfredsstilt av OpenStack
***********************************************************

.. csv-table:: Tabell 32: Oversikt
    :header: "Eksisterende krav", "Nye krav", "OpenStack", "Utvikles videre"

    "Tilbyr brukere full tilgang til et gitt antall VM’er definert av administrator", "", "Ja", "Nei"
    "IP-Adresse på HiGs nett", "", "Ja", "Nei"
    "Rulle ut flere VM'er med en gitt config(10)", "", "Ja", "Nei"
    "Administrere batcher som er rullet ut", "", "Nei", "Ja"
    "", "Mulighet for enkel administrering av VM'er for sluttbrukere", "Ja", "Nei"
    "", "Lastbalansering", "Ja", "Nei"
    "", "Skalering", "Ja", "Nei"
    "", "Webgrensesnitt", "Ja", "Ja"
    "", "Regnekraft som tjeneste", "Nei", "Ja"

Spesifisering av krav som skal utvikles videre
***********************************************

**Rulle ut flere vm’er med en gitt config**

I den eksisterende løsningen har administrator mulighet for å sette opp en konfigurasjon for et sett med virituelle maskiner som han kan rulle ut så mange sett som ønskelig. En slik konfigurasjon kan også lagres, slik at det kan hentes opp igjen på et senere tidspunkt. Dette blir gjort ved hjelp av kommandolinje og konfigurasjonsfiler. Et slikt sett med instanser kalles en tenant i OpenStack. Det finnes ingen implementasjon av en samling tenants, og følgelig må dette utvikles for å tilfredsstille eksistrende funksjonalitet. Ett sett med tenants vil fra nå av kalles for en batch. Da vil altså en tenant reflektere en gruppe i ett gitt emne og en batch reflekterer alle gruppene i et enkelt emne. 

Denne funksjonaliteten skal realiseres i Horizon

**Administrere batcher som er rullet ut**

Siden eksisterende løsning ikke har konseptet batch, det vil si en abstraksjon for en samling prosjekter, finnes det heller ingen mulighet for å gjøre operasjoner på en slik. F.eks å slette alle gruppene i et emne på en gang, eller å liste alle prosjekter som hører til et spesifikt emne. Denne funksjonaliteten må følgelig også implementeres i den nye løsningen, og vil være en naturlig utvidelse av kravet ovenfor. 


**Webgrensesnitt**

Løsningen skal kunne administreres ved hjelp av ett webgrensesnitt. Både faglærer og elever skal ha tilgang til dette grensesnittet med respektive rettigheter. Openstack oppfyller alleredet kravet om et webgrensesnitt med modulen Horizon. Det som spesifiseres av krav vil derfor også måtte tilfredstille kravene Horizon stiller til videre utvikling. Horizon viser til Python PEP8-stil når det gjelder python, samt Django’s Style Guide når det gjelder Templates. Foruten om dette følger de CSS,XHTML og javascript  -standarer som er oppgitt her http://horizon.openstack.org/contributing.html 

**Regnekraft som tjeneste**

Det skal være mulig for studenter og ansatte å flytte en virtuell maskin fra sin egen maskin opp til OpenStack via webgrensesnittet, slik at man får mulighet til å teste programvare o.l på bedre maskinvare enn man har fysisk tilgjengelig på egen maskin. Denne funksjonaliteten finnes ikke i eksisterende løsning, og heller ikke i OpenStack via webgrensesnittet. Det er dog støtte for å registrere disk-image i både VMWare  og VirtualBox sitt diskformat, men dette skjer via kommandolinjen.

**Use case**


.. figure:: use_case_v2.png

    Figure 29: Use-case V2

Høynivå use-case
-----------------

 
+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case ID**            | 1                                                                                         |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case navn**          | Create batch                                                                              |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hensikt**                | Opprette et sett prosjekter med et gitt antall instanser                                  |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hovedrolle**             | Admin                                                                                     |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Arbeidsflyt**            | **Brukerens handlingssmønster**           |                **Systemrespons**              |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Legg instanser i batchens konfigurasjon   | Vis listen med instanser som skal opprettes   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Oppgi antall prosjekter og navngi batchen | Kjør Use-case 3                               |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Start opprettingen                        | Vis tekstfelt for input                       |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Kjører Use-case 2                             |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Starter instansene                            |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Opprett batchen i databasen                   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Alternativ arbeidsflyt** |                                           | Dersom instansene ikke starter opp, må de     |
|                            |                                           | bygges på nytt. Eventuelt gis beskjed om at   |
|                            |                                           | maksgrense for antall instanser er nådd.      |
+----------------------------+-------------------------------------------------------------------------------------------+


Jajajajajaj



+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case ID**            | 2                                                                                         |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case navn**          | Create batch                                                                              |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hensikt**                | Opprette et sett prosjekter med et gitt antall instanser                                  |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hovedrolle**             | Admin                                                                                     |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Arbeidsflyt**            | **Brukerens handlingssmønster**           |               **Systemrespons**               |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Legg instanser i batchens konfigurasjon   | Vis listen med instanser som skal opprettes   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Oppgi antall prosjekter og navngi batchen | Kjør Use-case 3                               |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Start opprettingen                        | Vis tekstfelt for input                       |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Kjører Use-case 2                             |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Starter instansene                            |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Opprett batchen i databasen                   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Alternativ arbeidsflyt** |                                           | Dersom instansene ikke starter opp, må de     |
|                            |                                           | bygges på nytt. Eventuelt gis beskjed om at   |
|                            |                                           | maksgrense for antall instanser er nådd.      |
+----------------------------+-------------------------------------------------------------------------------------------+

3

+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case ID**            | 3                                                                                         |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case navn**          | Create batch                                                                              |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hensikt**                | Opprette et sett prosjekter med et gitt antall instanser                                  |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hovedrolle**             | Admin                                                                                     |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Arbeidsflyt**            |  **Brukerens handlingssmønster**          |                **Systemrespons**              |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Legg instanser i batchens konfigurasjon   | Vis listen med instanser som skal opprettes   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Oppgi antall prosjekter og navngi batchen | Kjør Use-case 3                               |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Start opprettingen                        | Vis tekstfelt for input                       |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Kjører Use-case 2                             |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Starter instansene                            |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Opprett batchen i databasen                   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Alternativ arbeidsflyt** |                                           | Dersom instansene ikke starter opp, må de     |
|                            |                                           | bygges på nytt. Eventuelt gis beskjed om at   |
|                            |                                           | maksgrense for antall instanser er nådd.      |
+----------------------------+-------------------------------------------------------------------------------------------+

4

+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case ID**            | 4                                                                                         |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case navn**          | Create batch                                                                              |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hensikt**                | Opprette et sett prosjekter med et gitt antall instanser                                  |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hovedrolle**             | Admin                                                                                     |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Arbeidsflyt**            |  **Brukerens handlingssmønster**          |                **Systemrespons**              |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Legg instanser i batchens konfigurasjon   | Vis listen med instanser som skal opprettes   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Oppgi antall prosjekter og navngi batchen | Kjør Use-case 3                               |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Start opprettingen                        | Vis tekstfelt for input                       |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Kjører Use-case 2                             |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Starter instansene                            |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Opprett batchen i databasen                   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Alternativ arbeidsflyt** |                                           | Dersom instansene ikke starter opp, må de     |
|                            |                                           | bygges på nytt. Eventuelt gis beskjed om at   |
|                            |                                           | maksgrense for antall instanser er nådd.      |
+----------------------------+-------------------------------------------------------------------------------------------+

5

+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case ID**            | 5                                                                                         |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case navn**          | Create batch                                                                              |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hensikt**                | Opprette et sett prosjekter med et gitt antall instanser                                  |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hovedrolle**             | Admin                                                                                     |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Arbeidsflyt**            |  **Brukerens handlingssmønster**          |                **Systemrespons**              |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Legg instanser i batchens konfigurasjon   | Vis listen med instanser som skal opprettes   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Oppgi antall prosjekter og navngi batchen | Kjør Use-case 3                               |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Start opprettingen                        | Vis tekstfelt for input                       |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Kjører Use-case 2                             |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Starter instansene                            |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Opprett batchen i databasen                   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Alternativ arbeidsflyt** |                                           | Dersom instansene ikke starter opp, må de     |
|                            |                                           | bygges på nytt. Eventuelt gis beskjed om at   |
|                            |                                           | maksgrense for antall instanser er nådd.      |
+----------------------------+-------------------------------------------------------------------------------------------+

6

+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case ID**            | 6                                                                                         |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case navn**          | Create batch                                                                              |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hensikt**                | Opprette et sett prosjekter med et gitt antall instanser                                  |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hovedrolle**             | Admin                                                                                     |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Arbeidsflyt**            | **Brukerens handlingssmønster**           |                **Systemrespons**              |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Legg instanser i batchens konfigurasjon   | Vis listen med instanser som skal opprettes   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Oppgi antall prosjekter og navngi batchen | Kjør Use-case 3                               |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Start opprettingen                        | Vis tekstfelt for input                       |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Kjører Use-case 2                             |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Starter instansene                            |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Opprett batchen i databasen                   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Alternativ arbeidsflyt** |                                           | Dersom instansene ikke starter opp, må de     |
|                            |                                           | bygges på nytt. Eventuelt gis beskjed om at   |
|                            |                                           | maksgrense for antall instanser er nådd.      |
+----------------------------+-------------------------------------------------------------------------------------------+

7

+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case ID**            | 7                                                                                         |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case navn**          | Create batch                                                                              |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hensikt**                | Opprette et sett prosjekter med et gitt antall instanser                                  |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hovedrolle**             | Admin                                                                                     |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Arbeidsflyt**            | **Brukerens handlingssmønster**           |                **Systemrespons**              |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Legg instanser i batchens konfigurasjon   | Vis listen med instanser som skal opprettes   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Oppgi antall prosjekter og navngi batchen | Kjør Use-case 3                               |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Start opprettingen                        | Vis tekstfelt for input                       |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Kjører Use-case 2                             |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Starter instansene                            |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Opprett batchen i databasen                   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Alternativ arbeidsflyt** |                                           | Dersom instansene ikke starter opp, må de     |
|                            |                                           | bygges på nytt. Eventuelt gis beskjed om at   |
|                            |                                           | maksgrense for antall instanser er nådd.      |
+----------------------------+-------------------------------------------------------------------------------------------+

8

+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case ID**            | 8                                                                                         |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Use case navn**          | Create batch                                                                              |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hensikt**                | Opprette et sett prosjekter med et gitt antall instanser                                  |
+----------------------------+-------------------------------------------------------------------------------------------+
| **Hovedrolle**             | Admin                                                                                     |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Arbeidsflyt**            | **Brukerens handlingssmønster**           |                **Systemrespons**              |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Legg instanser i batchens konfigurasjon   | Vis listen med instanser som skal opprettes   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Oppgi antall prosjekter og navngi batchen | Kjør Use-case 3                               |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            | Start opprettingen                        | Vis tekstfelt for input                       |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Kjører Use-case 2                             |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Starter instansene                            |
+----------------------------+-------------------------------------------+-----------------------------------------------+
|                            |                                           | Opprett batchen i databasen                   |
+----------------------------+-------------------------------------------+-----------------------------------------------+
| **Alternativ arbeidsflyt** |                                           | Dersom instansene ikke starter opp, må de     |
|                            |                                           | bygges på nytt. Eventuelt gis beskjed om at   |
|                            |                                           | maksgrense for antall instanser er nådd.      |
+----------------------------+-------------------------------------------------------------------------------------------+


Csv-tabell:

.. csv-table:: Csv

    "Use-case ID", "1"
    "Use-case navn", "Create batch"
    "Hensikt", "Opprette et sett prsjekter med et gitt antall instanser"
    "Hovedrolle", "Admin"
    "Arbeidsflyt", "Brukerens handlingsmønster", "Systemrespons"
    "", "Legg instanser i batchens konfigurasjon", "Vis listen med instanser som skal opprettes"
    "", "Oppgi antall prosjekter og navngi batchen", "Kjør Use-case 3"
    "", "Start opprettingen", "Vis tekstfelt for input"
    "", "", "Kjører Use-case 2"
    "", "", "Starter instansene"
    "", "", "Opprett batchen i databasen"
    "Alternativ arbeidsflyt", "Dersom instansene ikke starter opp, må de bygges på nytt. Eventuelt gis beskjed om at maksgrense for antal instanser er nådd."



Ikkefunksjonelle krav
----------------------

Ytelse
*******

Brukeropplevelsen skal stå i fokus. Å jobbe på en virtuell maskin skal ikke på noen måte oppleves tregt, og ytelsen skal være så nært en fysisk maskin med samme maskinvare som mulig.


Pålitelighet
*************

Systemet skal ha en oppetid på 99.9%.  Dette tilsvarer ca 8 timer og 45 minutter nedetid per år, eller 86 sekunder per dag.

Tilgjengelighet
****************

Systemet skal kun være tilgjengelig på HiGs interne nettverk, men ha internettilgang. Lagringsnettet skal ikke være tilgjengelig utenfor controller-noden/compute-nodene.

Sikkerhet
**********




Designbegrensninger
********************

I forhold til hardware ligger det naturlige begrensninger i utstyret som er tilgjengelig. OpenStack anbefaler en kontroller-node med minimum 12 GB RAM, og Compute-noder med minumum 32GB RAM.  I dette prosjektet har vi kun tilgjengelig servere med 2-4 GB RAM pr. node. Dette er litt i underkant av hva som er anbefalt, men nok for å få satt opp et fungerende oppsett med et begrenset antall instanser.

.. raw:: pdf

  PageBreak

Teori
########

Hva er nettsky?
----------------


**Kopiert til** Innledning_. (Kan/skal dette fjernes?)

*En "nettsky" (Cloud-computing)  er levering av databehandling som en tjeneste snarere enn et produkt, der delte ressurser, programvare og informasjon er gitt til datamasiner og andre enheter som et verkøty over nettverket (internett).*
*Cloud Computing (nettverkssky) er definert som tilgangen til datamaskiner og deres funksjonalitet via internett, eller et lokalt nettverk. Brukerene av en slik nettverkssky får tradisjonelt tilgang til disse tjenestene via en webtjeneste, enten via en tradisjonell PC eller en mobil applikasjon. Grunnen til at det kalles en nettsky, er at tjenestens fysiske lokasjon er usynlig for brukeren, og også ofte for de som leverer nettskyen. Det skal ikke være mulig for tjenesteleverandøren å peke ut at bruker X's data ligge rpå server Y. Selve skyen er rent teknisk et sett maskiner og webtjenester som har implementert cloud computing so tjeneste,*

*I en verden i en stadig framgang har nettskyen gjort sitt inntog for mannen i gata, kanskje nesten uten at man tenker opver det selv. "Alt" lagres i skyen; e-post, kontakter, bokmerker, kalendere, dokumenter, bilder m.m. Innholdet er alltid synkronisert mellom mobiltelefonen, laptopen, kontor-PC'en og nettbrettet. Tilgjengelighet har blitt alfa og omega, og nå skal også fysiske maskiner inn i skyen i form av virtuelle maskiner. Slike løsninger gjør hverdagen mer effektiv, og vil forekle lab-arbeid i forbindelse med studier av datasystemer. Ufordringene ligger i ytelse, konfigurasjon og skalerbarhet.*


.. role:: rubric

:rubric:`(Wikipedia er nok brukt som kilde her, få med url...)`


Virtualisering
---------------

Når det gjelder datamaskiner, er virtualisering å lage en virtuell versjon av noe, som en hardware-plattform, et operativsystem, lagringsenhet eller nettverksressurser.
Ved hjelp av virtualisering kan man installere et operativsystem på en virtuell maskin i et virtualiserings-program (VMware, Virtualbox), som da blir lagret som filer på harddisken. Slik kan man teste et operativsystem uten å installere det på selve harddisken over, eller ved siden, av det operativsystemet som allerede er installert.  

OpenStack
----------

OpenStack er et cloud-computing-prosjekt som tilbyr Infrastructure as a Service (IaaS), startet av Rackspace og Nasa i juli 2010. Per 17.april 2012 har over 150 bedrifter sluttet seg til prosjektet, som AMD, Intel, Canonical, SUSE Linux, Red Hat, Cisco, Dell, HP og IBM (ref http://openstack.org/community/companies/)

Første versjon, Austin, ble sluppet 21. oktober 2010, og har siden da vært i kontinuerlig utvikling. Nyeste versjon er Essex, sluppet 5.april 2012.

Hovedmålet til OpenStack-prosjektet er å gi alle organisasjoner mulighet til å opprette og tilby nettskyer som kan kjøre på standard maskinvare.

Bakgrunn/fnuz
**************

Moduler
*******

Selve OpenStack er et modulbasert prosjekt, hvor hovedmodulene er Compute (Nova), Image Service (Glance) og Identity Service (Keystone). Disse modulene er det absolutte minimum av hva som må implementeres i et fungerende system. De øvrige modulene som er beskrevet under er valgfrie, og noen av dem er heller ikke en offisiell del av prosjektet enda. Siden det er modulbasert, kan alle modulene, samt tjenestene tilhørende de forskjellige modulene, både dupliserers og distribueres til flere forskjellige fysiske servere. Dette gjør systemet meget skalerbart og enkelt og lastbalansere.
OpenStack er skrevet i Python.


RabbitMQ
.........
RabbitMQ er ikke en del av OpenStack, men er en avhengighet i systemet. RabbitMQ er den tjenesten de forskjellige modulene bruker for å snakke med hverandre. Teknologien bak er AMQP [#]_. Enkelt forklart består dette i at en tjeneste sender en “message” (forespørsel) som så blir tolket, og sendt til rett mottaker. OpenStack benytter kun asynkrone kall til RabbitMQ for å sikre at ingen tjenester blir hengde å vente på hverandre.

.. [#] Advanced Messaging Queue Protocol

Nova
.....

Nova er kjernemodulen i OpenStack som tar seg av opprettelsen og administreringen av de virtuelle maskinene, samt håndtering av nettverk. Nova modulen er delt opp i forskjellig tjenester, som har sin spesifikke oppgave.

**Nova-api**

Tilbyr et grensesnitt mot brukerene, som tar i mot kall til de forskjellige tjenestene. Det er støtte for OpenStacks eget API, Amazons EC2 API samt et eget administrativt API forbeholdt systemadministratorer. Sistnevnte er realisert i form av klienten *nova-manage*. I tillegg til å ta i mot disse kallene, er det også denne tjenesten som initierer handlinger hos de andre tjenestene (f. eks å starte en instans). Nova-api står også for sjekk mot brukerens kvoter i prosjektet det jobbes på. Nova-api kjøres typisk på den maskinen man velger som controller.

**Nova-compute**

Denne tjenesten står for oppretting og terminering av virtuelle maskiner. For å realisere dette, snakker nova-compute med de forskjellige API’ene for de hypervisorene som er støttet. Eksempelvis libvirt for KVM/qemu og XenAPI for XenServer/XCP. Når nova-api har mottatt en forespørsel om en ny virtuell maskin, blir den plassert i køsystemet og hentet ned fra køsystemet av nova-compute. Deretter blir det kjørt en rekke systemkommandoer for å gjennomføre forespørselen som kom gjennom API’et. En typisk serie av systemkommandoer ved oppstart av en ny virtuell maskin vil være:

- Lage konfigurasjonsfil for virtualiseringsplatformen man har valgt. F.eks lage en XML-fil for libvirt
- Sette opp brannmurregler i iptables
- Opprette en katalog der blant annen disk-filen til den nye virtuelle maskinen blir lagret. Disse ligger under /var/lib/nova/instances/instance-XXXXXXX
- Kopiere over image-fil med operativsystem fra glance til den compute-noden som skal kjøre den akutelle virtuelle makinen. Dette gjøres kun dersom det valget imaget aldri har blir kjørt fra compute-noden. Imagene blir lagret i katalogen /var/lib/nova/_base.
- Kopiere over image-filen til den nye instansens katalog. Dersom image-filen allerede finnes på compute-noden blir den ikke hentet fra glance først.
- Kjører kommandoer for å starte instansen. Hvilke kommandoer som blir kjørt avhenger her av hvilken hypervisor som er valgt.

Underveis i denne prosessen vil det hele tiden rapporteres til databasen som tilstanden på den nye instansen.

**Nova-volume**

Håndterer opprettelse, sletting og tilegning av fysisk lagringsplass til instanser. Man har mulighet til å legge til ekstra lagringsplass på instansene i etterkant av opprettelsen, slik at man enkelt kan løse utfordringer i forbindelse med dette. Volumene blir typisk hentet fra iSCSI. Nova Volume tilsvarer Amazons Elastic Block Storage. Tjenesten fungerer på akkurat samme måte som compute. Det blir sendt forespørsler til køsystemet, som nova-volume henter ned, og prosesserer.

**Nova-network**

Fungerer konseptuelt på akkurat samme måten som volume og compute, og håndterer følgelig alle forespørsler i køsystemet som har med nettverk å gjøre. Dette omfatter opprettelse av nettverksbroer, endring i brannmur, tildeling av nettverk, DHCP-oppsett og tildeling av floating-IP’s. Nova-network er dypere forklart i `Nettverk i OpenStack`_.

**Nova-schedule**

Denne tjenesten tolker alle meldinger i køsystemet, og sender dem til den noden forespørselen gjelder. F.eks en forespørsel om å terminere en virtuell maskin skal sendes til en nova-compute node. I nåværende utgave av OpenStack kjører nova-schedule i noe man kaller “muliti”-mode. Man kan velge en separat algoritme for compute og en for volume. Det tilbys tre forskjellige algoritmer:

- chance
- filter
- simple

*Chance* velger en tilfeldig node på tvers av alle tilgjengelighetssoner. *Filter* gir muligheten til å spesifere hvilken node man vil bruke. *Simple* velger den noden som på det tidspunktet meldingen blir tolket, har minst last. Chance er standard for volume, og filter er standard for compute.


Glance
.......

De virtuelle disk-imagene blir administrert via Glance, og støtter disk-formater som Raw, Machine (kernel/ramdisk outside of image, a.k.a. AMI), VHD (Hyper-V), VDI (VirtualBox), qcow2 (Qemu/KVM), VMDK (VMWare) og OVF (VMWare, andre). Disse disk-imagene kan lagres på flere forskjellige måter. Man kan bruke lokalt filsystem (/var/lib/glance/images), Swift, dirkete hos Amazon S3, eller HTTP. Opplastingen og registreringen foregår enten gjennom Glance API eller EC2-api’et. Glance består av to tjenester, i tillegg til en database:

- glance-api
- glance-registry

Glance-api tar i mot alle API-kall som omhandler registrering av nye image, overføring av image til compute-noder og lagring av image. Glance-registry lagrer og prosesserer metadata angående nye image.

Keystone
........

Keystone er autentiserings- og identitetstjenesten i OpenStack. Alle modulene i OpenStack benytter seg av denne som standard. Keystone er i all hovedsak en database som inneholder informasjon om brukere, prosjekter, roller, tokens, tjenester, endpoints for tjenestene. Hvilket system som brukes for den databasen kan man velge selv, men det vanligster er en form for SQL-database. Det er også støtte for LDAP [#]_ og KVS [#]_. Ved hjelp av disse tilbys det autentisering på flere forskjellige måter. En bruker kan autentiseres ved:

- Brukernavn og passord
- Brukernavn og API-nøkkel

Keystone introduserer noen konsepter i forbindelse med sine tjenester:

**User**

En bruker er som regel en representasjon av en person, som skal ha tilgang til de forskjellige tjenestene. Men, en bruker kan også være en tjeneste i seg selv.

**Token**

Konseptet med tokens er ganske enkelt. En token er tilfeldig generert tekststreng som brukes for å gi brukere tilgang til tjenester. En token er gitt et sett privilegier (scope), der man f.eks kan få administrative rettigheter.

**Tenant**

Er i all hovedsak det keystone kaller et prosjekt. Alle instanser, nettverk, volumer, IP-adresser, kvoter og sikkerhetsregler er knyttet til en tenant.

**Service**

Alle tjenestene i OpenStack må registreres i Keystone. Hver tjeneste har en bruker knyttet til seg, og hver tjeneste tilbyr et eller flere endpoint som brukerne kan akesessere tjenester gjennom.

**Endpoint**

Et endpoint er en nettverksadresse som peker til en tjeneste.

**Role**

Alle brukere knyttes til et prosjekt med en bestemt rolle. Til hver rolle er det tilknyttet et sett med privilegier og rettigheter. I Keystone så er listen over roller en bruker har i de forskjellige prosjektene knyttet til den token man får ved en vellykket autentisering.

.. [#] Lightweight Directory Access Protocol
.. [#] Key Value Storage

Horizon
........

Horizon er webgrensesnittet i OpenStack. Gjennom horizon får administratorer og brukere tilgang til den mest grunnleggende tjenestene. Brukere har adgang til å:

- Administrere instanser innenfor de prosjektene de er medlem i (opprette, slette, restarte)
- Ta snapshots av kjørende instanser, samt administrere disse (redigere, slette)
- Allokere såkalte floating IP adresser (se nettverkskapittelet)
- Administrere volumer innenfor de prosjektene de er medlem i (opprette, slette, knytte til instans, fjerne fra instans)
- Administrere sikkerhetsgrupper, det vil si grupper av brannmurregler for instansene i prosjektet
- Administrere nøkkelpar for tilgang til instanser

En administrator vil i tillegg til nevnte rettigheter, ha mulighet til å:

- Monitorere samlet ressursbruk for alle prosjekter, fra tidenes morgen
- Håndtere alle kjørende instanser i hele implementasjonen
- Få en oversikt over registrerte tjenester
- Definere “flavors”, det vil si forhåndsdefinerte maskinvarekonfigurasjoner som brukerne kan velge ved opprettelse av instanser
- Administrere alle disk-images som er registrert
- Administrere prosjekter (opprette, endre, slette, modifisere tilknyttede brukere)
- Administrere brukere (opprette, endre, slette)
- Sette kvoter per prosjekt. En kvote inneholder maksimum antall CPU kjerner, instanser, MB RAM, floating IP’er, volumer (og samlet størrelse på disse) og filer man kan injisere i instanser (og maks størrelse på disse)

Horizon kjører via webserveren Apache via mod_wsqi, og krever kun en database i tillegg. All informasjon blir hentet fra andre tjenester via deres API’er, slik at selve web-apllikasjonen lagrer svært lite data i seg selv.

Swift
.......

Swift er OpenStacks modul for det man kaller “object storage” i sky-verden. Object Storage er annen måte å tenke lagring på, i forhold til tradisjonelle filsystemer. Funksjonaliteten er mye den samme, men man vil ikke kunne montere Object Storage på samme måte som man kan fra f.eks et SAN eller et NAS. Swift kan sammenlignes direkte med Amazons S3. Object Storage baserer seg på følgende konsepter:

**Accounts og Account servere**

Brukere av lagringssystemet må identifiseres og autentiseres (f.eks via keystone) for å få tilgang til sine filer. Hver konto er tilknyttet en bruker, som igjen har sine “containers” tilknyttet seg.

*Containers og objects**

Containers er nærmest ekvivalente til mapper i tradisjonelle filsystemer. Forskjellen er at containers ikke kan nøstes på samme måte. Objects er på samme måte ekvivalent til filer. Et object kan ha en mengde metadata knyttet til seg i form “key-value” par. Dette er ment for å beskrive objekter best mulig.

Quantum
..........

Quantum er tjeneste for virtuelle L2 [#]_ nettverk. Den tilbyr et API for nettverkstrafikk mellom enheter fra de forskjellige OpenStack tjenestene, hovedsaklig i form av virtuelle switcher. For å realisere dette, bruker man en plugin (f.eks Open vSwitch eller Cisco Quantum plugin), slik at Quantum API blir et abstraksjonslag på samme måte som Nova. De virtuelle switchene vil ha samme muligheter for konfigurasjon som fysiske switcher, f.eks QoS, port security, monitorering osv. Det mest naturlige er å knytte Quantum sammen med Nova, for å skape interne logiske nett for prosjekter. Quantum er også natulig å kombinere med Melange. I skrivende stund mangler Quantum muligheten for å lage identiske interne nett, slik at muligheten til å ha identiske prosjekter, med identiske interne nett (som ikke er det samme logisk nettet) ikke er til stede.


Melange
..........

Melange er en tjeneste med fokus på IPAM (IP Address Management) og DHCP, for å gi en mer mer fleksibel løsning for L3 [#]_ addressering av virtuelle maskiner enn den som er innebygget i Nova. I fremtiden er det ventet at den også vil håndtere DNS, ruting og gateway mot internett, og i så måte ta over mye av de standard nettverksløsningene som finnes i nova i nåværende utgave.

Melange-modulen er meget ny, og ble først innlemmet som en offisiell modul i Essex-utgaven. Det foreligger mange dokumenter på Melange sin fremitd, både som uavhengig og modul, og hvordan den skal implementeres med nova. Blant annet er det planlagt at den skal slåes sammen med Quantum. 

.. [#] OSI Layer 2 - Fysisk adressering
.. [#] OSI Layer 3 - Nettverkslaget, logisk adressering (IP)

MVC
***

Model view controller er et design-pattern som er designet for å skille data, logikk og presentasjon i et grensesnitt. 

Ett typisk MVC vil inneholde en modul som behandler forespørsler fra en bruker(controller), en modul som  presenterer data(view) og en for å formidle data eksempelvis til og fra en database(model). 

Ett typisk MVC vil a ha en modul (View) som rendrer et GUI for brukeren, en modul (Controller) som bestemmer hva som skal rendres og med hvilke data, og en modul (Model) som fungerer som et abstraksjonslag mot datalagringen

Når en bruker trykker på en link på en nettleser, er det controlleren sitt ansvar å behandle forespørselen, og sende den videre til riktig view. Når viewet får forespørselen spør den modellen etter riktig data, og viser resultatet frem for brukeren.


Django
******

Django er ett web-rammeverk for Python, med sterk fokus på effektivitet. Det er opprinnelig designet for publisering i avisredaksjoner men har i senere tid gått over til å blir et rammevek for generell webutvikling. Styrken i Django ligger i måten de har implementer MVC, ved å skille logikk, data, og presentasjon på en slik måte sørger de for ett kjapt utviklingsmiljø med store muligheter for utvidelser. Nå er det sagt at det er ett mvc, men en viktig ting å nevne i forhold til at de har implementert mvc på en spesiell måte er: De bruker et template system som gjør at et view ikke nødvendigvis er hvordan data skal vises men hvilken data som blir vist. Og da utgjør template-systemet rollen for hvordan data skal vises.

Strukturen for ett django-prosjekt ser slik ut:

| Mitt prosjekt
|         manage.py
|         minside
|                
|                settings.py     //registrere din applikasjon
|                urls.py         //her vil du dirigere til din applikasjon
|                wsgi.py  

Prosjektet håndterer utvidelser (kalt applikasjoner) som individiuelle moduler uavhengig av hverandre. Slik at dersom en bruker eksempelvis har laget en applikasjon i sitt prosjekt for å vise en kalender skal denne kunne benyttes i hvilket som helst annet prosjekt.

Med dette utgangspunktet registrerer man applikasjoner som har følgende struktur.

| minapplikasjon
|         __init__.py
|         models.py
|         views.py
|         tests.py

En applikasjon som er registrert slik vil også være knyttet til en mappe med tilsvarende navn som som inneholder templates. 


Horizon(oppbygging)
*******************

Horizon baserer seg på pyton med Django som web-rammeverk. Dette innebærer i hovedsak at Django´s implementasjon av MVC dikterer hvordan Horizon opererer. 

Horizon baserer seg i utgangspunktet på følgende 3 applikasjoner: Syspanel, Dash og Settings. Disse er kalt dashboards og består igjen av panels som er spesifikt for Horizon, panels har sine egne views og controller. Dette er ett eksempel på Django’s styrke, altså at mvc er gjenbrukbart gjennom hele systemet ved bruk av applikasjoner.

En horizon-applikasjon er strukturert på følgende måte:

| syspanel
|        dashboad.py
|        templates
|        panel
|
|                panel.py
|                urls.py
|                views.py
|                forms.py
|                templates

Model
.....
Horizon benytter seg ikke av model på den tradisjonelle Django-metoden. Grunnen til dette er at Horizon kobler seg direkte til databasene fra de andre Openstack-modulene. De har sin egen abstraksjon mot databaselaget som er designet for Django, slik at Django behandler datasettene på samme måte, bare ikke ved hjelp av sine egne modeller.



.. raw:: pdf

  PageBreak


Design
#######

.. role:: rubric

:rubric:`Hovedtrekk fra design av system beskrives. Fullstendig designdokument bør være vedlegg til prosjektrapporten, mens dette punktet omhandler diskusjon av sentrale forhold. Ulike alternative design som studentene vurderte bør beskrives og valg av alternativ begrunnes.`

Løsning av use-cases
---------------------

.. raw:: pdf

  PageBreak

Gjennomføring
##############

*“Getting OpenStack up and running does earn you the title of Jedi Knight.”*


Implementasjon
---------------

.. role:: rubric

:rubric:`Anvendelsen av ulike verktøy og utviklingsmiljøer beskrives. Er det gjort bevisste valg av verktøy, begrunnes disse. Videre beskrives valgte prinsipper og standarder i kodingen. Eksempler fra kildekoden trekkes frem for å vise hvordan dette er etterlevd i praksis.`

Nettverk
*********

.. figure:: arkitektur.png
   :scale: 300%

   Figur 4: Arkitektur


.. csv-table:: Tabell 9: Routere
   :header: "**Enhet, modell**", "**Nettverkskort**", "**MAC-adresse**", "**IP/Mask**", "**Gateway**"
   
   "Brighton, HP ProLiant DL320", "eth0", "00:1f:29:13:02:8a", "DHCP", " "
   "", "eth1", "00:1f:29:13:02:8b", "10.0.0.1/30", "10.0.0.2"
   "SkyRoute, Cisco 2800", "fa0/0", "ec:44:76:68:16:94", "10.0.0.2/30", ""
   "", "fa0/1", "ec:44:76:68:16:95", "192.168.99.1/24", ""
   "", "fa0/1.10", "''", "192.168.10.1/24", ""
   "", "fa0/1.30", "''", "192.168.30.1/24", ""


.. csv-table:: Tabell 10: Switch
   :header: "**Enhet, modell, Management IP**", "**Port**", "**Hastighet**", "**VLAN(s)**", "**Trunk status**"
   :widths: 25, 15, 15, 20, 10  

   "switchd13d24, Cisco SG-200 26, 192.168.99.254/24", "GE1-12", "1000Mbit", "10 (public)", "av"
   "", "GE13-18", "1000mbit", "100-115 (VLAN for VM'er)", "på"
   "", "GE19-24", "1000mbit", "30 (storage)", "av"
   "", "GE25", "1000Mbit", "99 (native/management)", "av"
   "", "GE26", "1000Mbit", "10, 30, 99", "på"


.. csv-table:: Tabell 11: Servere
   :header: "**Navn**", "**CPU**", "**RAM**", "**Disk**", "**IP**"

   "dublin", "Intel Xeon 3060 2.4 GHz", "4GiB", "2 x 250 GB", "eth0: 192.168.10.2, eth1: oppe - ingen IP"
   "manchester", "Intel Xeon 3060 2.4 GHz", "4GiB", "2 x 250 GB", "eth0: 192.168.10.10, eth1: ioppe - ingen IP"
   "cardiff", "Intel Xeon 3060 2.4 GHz", "2GiB", "2 x 250 GB", "eth0: 192.168.10.11, eth1: oppe - ingen IP"
	 "newcastle", "Intel Xeon 3060 2.4 GHz", "2GiB", "2 x 250 GB", "eth0: 192.168.10.12, eth1: oppe - ingen IP"
   "kingston", "Intel Xeon 3060 2.4 GHz", "4GiB", "12 x 250 GB", "bond0: 192.168.10.185, eth0: oppe - link aggregation, eth1: oppe - link aggregation"

I prosjektperioden vil nettverkstopologien være som vist i figuren. Satt i produksjon vil man antageligvis fjerne routeren og DHCP-serveren vi ser øverst i figuren, slik at man benytter seg av offentlige IP’er (globale IP’er delt ut fra HiG). For testformål har vi satt opp vårt eget lokale nettverk bak en dedikert linuxmaskin som kjører NAT og DHCP, slik at vi beskytter testoppsettet fra offentligheten, og unngår å forstyrre noe av HiGs infrastruktur.


På switchen er det satt opp ulike VLAN. Standard management-VLAN er flyttet vekk fra VLAN 1, til VLAN 99, i følge beste praksis. VLAN 10 for internettilgang (public), et dedikert VLAN til lagringsnodene (VLAN 30, storage), og i tillegg er det satt opp åtte trunk-porter for trafikk mellom instansene. Det blir opprettet ett nytt VLAN for hvert prosjekt i OpenStack. Dette vil kunne bli et problem dersom man ruller ut i stor skala, siden maks teoretisk antall VLAN er 4096, og av dem igjen er noen reserverte. For vår oppdragsgiver vil nok dette neppe bli noe problem i første omgang, men gitt et scenario der hver student ved skolen skal få tilgang, i tillegg til de emnene som skal bruke systemet, vil dette bli et problem.

Løsningen på dette problemet kan imdlertid være på vei. Sommeren 2011 lanserte# Cisco nyheten VXLAN (Virtual eXtensible LAN). I korte trekk er dette en utvidelese av dagens VLAN-teknologi, der VLAN-ID feltet i pakken er doblet fra dagens 12 bit til 24 bit. Det åpner for et teoretisk maksimum på over 16 millioner (2^24) unike VLAN-ID’er. Et annet skaleringsproblem er utrulling av VLAN til ulike switcher. I dag er VTP [#]_ eneste mulighet, men det er ofte deaktivert av sikkerhetshensyn, og man er da tvunget til å konfigurere switchene mer eller mindre manuelt. VXLAN har muligheten for å distribusjon over lag 3 (f.eks IP). Muligheten for å bygge inn støtte for VXLAN i OpenStack er allerede i utviklerenes tanker<ref>, og det er allerede implementert støtte for en Cisco plugin i Quantum. Denne støtter imdlertid ikke VXLAN foreløpig.

Valget av DHCP-server falt på *dnsmasq*. Den har en meget enkel konfigurasjon, samtidig som den uten konfigurasjon over hodet, fungerer som DNS-forwarder for alle DHCP-klienter. Eksempel på konfigurasjon ligger i vedlegg B. For å få det interne nettverket bak routeren til å få kontakt med *dnsmasq* måtte det settes opp et DHCP-relay [#]_ i *SkyRoute*. I en cisco-router er slik funksjonalitet innebygget, og gjøres med kommandoen

::
  
  ip helper-address <ip>

på det nettverksgrensesnittet pakkene vil komme inn på. I vårt tilfelle innebærer det alle de virtuelle netverksgrensesnittene på **fa0/1**. I tillegg må det legges inn en statisk rute til vårt interne nett på brighton, vi kommandoen:

::

  route -add net 192.168.0.0 netmask 255.255.0.0 gw 10.0.0.2


Ruter som blir lagt inn med denne fremgangsmåten slettes ved restart, og kommandoen ble derfor lagt inn i oppstartsskriptet */etc/rc.local*.

*Iptables* er en modul i linuxkjernen, som driver filtrering av IP-pakker. Ved hjelp av denne kan man filtrere ut hvilke pakker som skal ha aksess til hvilke nett, og hvor de skal sendes. Man har også muligheten til å sette op NAT. Dette utnyttet vi for å dele ut internett til vårt interne nett via *brighton*. Disse filterne ble satt opp:

::
  
  iptables -A FORWARD -s 10.0.0.0/30 -i eth1 -j ACCEPT
  iptables -A FORWARD -s 192.168.10.0/24 -i eth1 -j ACCEPT
  iptables -A FORWARD -d 10.0.0.0/30 -i eth0 -j ACCEPT
  iptables -A FORWARD -d 192.168.10.0/24 -i eth0 -j ACCEPT
  iptables -A FORWARD -s 192.168.30.0/24 -i eth1 -j DROP
  iptables -A FORWARD -d 192.168.30.0/24 -i eth0 -j DROP
  iptables -A FORWARD -s 192.168.99.0/24 -i eth1 -j DROP
  iptables -A FORWARD -d 192.168.99.0/24 -i eth0 -j DROP
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

De tre første linjene aksepterer trafikk fra gitte nettverk ut mot internett. De tre neste aksepterer trafikk fra internett, til de samme nettverkene. De påfølgende fire linjene, sperrer trafikk både til og fra internett for **VLAN30** og **VLAN99**. Den siste linja forteller at pakker på veg ut mot internett skal oversettes med **NAT**, at alle skal bruke den samme globale IP-adressen, samt at pakkene skal sendes til **eth0**. For at dette skal fungere må man sette et kernel-flagg som muliggjør videresending av IPv4-adresser, slik:

::

  echo 1 > /proc/sys/net/ipv4/ip_forward

Dette blir imdlertid resatt når maskinen starter på nytt, derfor må flagget settes i filen */etc/sysctl.conf*. Filterne i iptables blir også resatt ved en omstart. Derfor ble konfigurasjonen lagret, ved hjelp av kommandoen

::

  iptables-save > /etc/iptables.conf

Konfigurasjonen blir hentet tilbake i oppstarten, ved å legge inn

:: 

   iptables-restore < /etc/iptables.conf

i oppstartsskriptet */etc/rc.local*.

.. [#] VLAN Trunking Protocol
.. [#] Tjeneste som lytter etter DHCPREQUEST fra andre nettverk, og videresender de til en gitt IP


Nettverk i OpenStack
*********************

Nettverksmodeller
.................

Tjenesten nova-network håndterer alle nettverksoppgaver i OpenStack. Det finnes tre forskjellige modeller å velge i mellom:
  - FlatNetworking
  - FlatDHCP
  - VLAN Network

Uavhengig av hvilken modell man velger, er det mange forskjellige muligheter for infrastruktur i OpenStack. Vi vil ikke gå i dybden på alle disse, men fokusere på den som er gjeldende for vårt oppsett.

Alle våre noder har to nettverkskort. På compute nodene er det ene av disse er satt opp som “public interface” med tilgang til internett. Det andre er satt opp uten IP-adresse. På volume noden er de to to nettverkskortene satt opp med aggregering, for å doble den teoretiske båndbredden fra 1 Gbps til 2 Gbps. Dette er fyldig forklart i bacheloroppgaven SkyHigh I/O <ref>. OpenStack setter opp en nettverksbro per prosjekt, bundet til nettverkskortet uten IP-adresse. Broen gir de virtuelle maskinene i samme prosjekt muligheten til å snakke med hverandre. I tillegg sørger nova-network for å legge inn regler i iptables, for å rute trafikk fra instansene til internett via den compute-noden instansen kjører på.

.. figure:: internal_net.png
   :scale: 300%

   Figur 5: Internt nettverk

**Flat Networking**

Dette er den enkleste modellen, der man definerer et subnet instansene skal bruke, og ved opprettelse blir det injisert en IP fra dette. Nettverksbroen for å binde sammen eksternt og internt nett må settes opp manuelt på alle noder i infrastrukturen. Alle instanser er koblet til den samme nettverksbroen, og man er begrenset til én slik. Dette gjør denne modellen mest aktuell for mindre implementasjoner.

**Flat DHCP**

Flat DHCP fungerer så og si på samme måten som Flat Networking, men her starter man en DHCP-server for å dele ut IP-adresser til instansene fra det spesifiserte subnettet. Alle instansene er fremdeles koblet til den samme nettverksbroen. DHCP-serveren som benyttes er dnsmasq, og denne settes opp til å lytte på DHCPDISCOVER på nettverksbroen.

I begge disse flate modellene får instansene delt ut offentlige IP-adresser, enten globalt rutbare eller, eller fra et lokalt nett det blir gjort NAT i. nova-network fungerer altså ikke som gateway.

**VLAN Network**

Denne modellen er standardmodellen, og også den vi har valgt. Her opprettes det et eget VLAN, et eget subnet og en egen nettverksbro for hvert prosjekt. For hvert av disse VLANene blir det startet en DHCP-server, og instansene blir tildelt en privat IP-adresse derfra som bare er tilgjengelig innenfor sitt VLAN. For å få tilgang til instansene må man enten benytte seg av VPN, eller konseptet floating IP’s.

CloudPipe er en spesiell instans som opptrer som VPN-server. For å få aksess til instansene må man sette opp en slik, og hente ut sertifikat og nøkkel fra denne. Alternativet til dette er å benytte seg av konseptet floating IP. Man definerer en sett IP-adresser, gjerne et helt subnet, med globale IP-adresser man kan legge til instansene. Måten det fungerer på, er at IP-adressen blir lagt til på prosjektets nettverksbro, og det blir opprettet iptables-regler for å rute trafikken til rett instans. Vi har valgt å bruke floating IP i vår implementasjon, med tanke på brukervennlighet. Her trengs det ingen komplisert oppkobling for sluttbrukeren.

Denne modellen passer godt i større implementasjoner, siden den er mest dynamisk. Her trengs ingen manuell konfigurasjon av nettverksbroer eller andre nettverkskort. Alt blir gjort dynamisk. Modellen avhenger av at man har nettverksutstyr som takler IEEE 802.1Q VLAN-tagging.


Floating og fixed IP adressering
................................

OpenStack bruker to konsepter for IP-adressering, fixed IP og floating IP. Alle instanser får en fixed IP fra sitt prosjekts respektive “fixed” nettverk. Hvordan denne deles ut, kommer ann på hvilken av nettverksmodellene man har var. Det subnettet fixed IP bruker, er ikke tilgjengelig utenfor instansene i samme prosjekt, og er følgelig å anse som et internt nett. Compute noden som instansene kjører på vil som tildligerere nevnt få satt opp regler i iptables for å rute trafikk inn og ut mot andre nett.

For å gi instansene en offentlig IP-adresse, må man tilegne den en floating IP. Å gjøre dette er en to stegs prosess. Først må man allokere en adresse fra et definert pool, og deretter må man koble denne adressen til en instans. I konfigurasjonen av nova definerer man et subnet med offentlig adresser man kan allokere floating IP adresser i fra. Dette trenger ikke nødvendigvis å være globalt rutbare adresser, men det må naturligvis være adresser på et nett som er tilgjengelig for brukeren.

Floating IP blir satt opp av nova-network. Det blir satt opp regler i iptables både for filtrering av trafikk og for nat. Itillegg blir adresser fysisk lagt til på det nettverkskortet som er defintert som public interface i novas konfigurasjon.

Her ser vi utdrag fra loggen etter at en floating IP (192.168.10.129) er tilknyttet en instans:

::

	2012-04-24 14:15:06 DEBUG nova.utils [req-0420a717-6545-4a2e-a02e-22837f484250 <user_id> <tenant_id>] 
	Running cmd (subprocess): sudo ip addr add 192.168.10.129/32 dev eth0 from (pid=13753) execute /usr/lib/python2.7/dist-packages/nova/utils.py:219
	2012-04-24 14:15:06 DEBUG nova.utils [req-0420a717-6545-4a2e-a02e-22837f484250 <user_id> <tenant_id>] 
	Running cmd (subprocess): sudo iptables-save -t filter from (pid=13753) execute /usr/lib/python2.7/dist-packages/nova/utils.py:219
	2012-04-24 14:15:06 DEBUG nova.utils [req-0420a717-6545-4a2e-a02e-22837f484250 <user_id> <tenant_id>] 
	Running cmd (subprocess): sudo iptables-restore from (pid=13753) execute /usr/lib/python2.7/dist-packages/nova/utils.py:219
	2012-04-24 14:15:06 DEBUG nova.utils [req-0420a717-6545-4a2e-a02e-22837f484250 <user_id> <tenant_id>] 
	Running cmd (subprocess): sudo iptables-save -t nat from (pid=13753) execute /usr/lib/python2.7/dist-packages/nova/utils.py:219
	2012-04-24 14:15:06 DEBUG nova.utils [req-0420a717-6545-4a2e-a02e-22837f484250 <user_id> <tenant_id>] 
	Running cmd (subprocess): sudo iptables-restore from (pid=13753) execute /usr/lib/python2.7/dist-packages/nova/utils.py:219

Før kallene til iptables, blir reglene generert av novas API. I dette tilfellet, vil følgende regel bli lagt til: 

::

	target     prot opt source               destination         
	SNAT       all  --  172.16.0.3           anywhere            to:192.168.10.129 


Installasjon av OpenStack
**************************

*Controller, compute osv.*

**NOTE: Veldig overordnet og i stikkordsform. Blir fixet nærmere jul!**

Krav til maskinvare og programvare:

På controlleren er anbefalt maskinvare en 64-bit x86 prosessor, 12 GB RAM, 30 GB diskplass og 1 stk gigabit-nettverkskort. For Volume storage to disker med 2 TB lagringsplass.
For compute-noder er anbefalt maskinvare en 64-bit x86-prosessor, 32 GB RAM, 30 GB diskplass og 2 stk  gigabit-nettverkskort. 
 
OpenStack er pakket for CentOS, Debian, Fedora, RHEL, Debian og Ubuntu.
Compute bruker PostgreSQL eller MySQL, Object storage bruker SQLite.

Ved hjelp av DevStack (http://devstack.org) kan man sette opp en fungerende OpenStack-installasjon med så lite som 2 kommandoer. DevStack er laget for å brukes i et utviklingsmiljø som et “proof-of-concept” hvor man kan teste de forskjellige komponentene, og er ikke anbefalt til bruk i produksjon. Installasjon av OpenStack via DevStack gjøres slik:

:: 

  git clone git://github.com/openstack-dev/devstack.git
  cd devstack; ./stack.sh

Selve installasjonen tar gjerne litt tid, men det er ingen konfigurasjon som må gjøres, og når installasjonen er ferdig har du en fullt fungerende OpenStack-installasjon.

En alternativ måte å installere OpenStack på er med scriptet til ManagedIT (https://github.com/managedit/openstack-setup). Dette er et script hvor du først legger inn all ønskelig konfigurasjon og scriptet installerer OpenStack via pakkebrønnen. Dette scriptet automatiserer rett og slett den manuelle installasjonen, og kan brukes i produksjon.

I tillegg kan man laste ned kildekoden fra Launchpad (https://launchpad.net/openstack), eller laste ned fra GitHub (https://github.com/openstack).

StackOps (http://stackops.com ) er et firma som har spesialisert seg på levering av OpenStack med hardware, og tilbyr en ISO-fil basert på Ubuntu 10.04 LTS (http://stackops.org ) spesialisert for OpenStack. Per 24. april 2012 er denne i versjon 0.5, og distribusjonen er modifisert til å utelukkende inneholde de komponentene som kreves for at OpenStack Nova skal kjøre.

Hvilken måte man velger å installere OpenStack på avhenger litt av hvordan man skal bruke den - skal man bare teste/gjøre utvikling vil scriptene fra DevStack og ManagedIT være tilstrekkelig. Planlegger man å bruke OpenStack i et produksjonsmiljø anbefales en manuell installasjon fra pakkebrønn, GitHub eller Launchpad. Man vil da få full kontroll over hele installasjonen og konfigurasjonen - men må følgelig ta et steg av gangen da det er mer konfigurasjon som må gjøres.


Manuell installasjon:

For komplett installasjonsguide, se http://docs.openstack.org/trunk/openstack-compute/install/content/ - her beskrives bare de overordnede steg for installasjon.

Tids-synkronisering som NTP må installeres, i tillegg til at det kreves en root-bruker eller en bruker med sudo-rettigheter.

Installer ntp

Installer keystone:

::

   sudo apt-get install keystone

Sett opp database, gjør nødvendige endringer i /etc/keystone/keystone.conf (admin-token o.l.), sett opp tenants, users og roles.

Installer Glance:

::

  sudo apt-get install glance

Sett opp database, gjør nødvendige endringer i config-filene i /etc/glance/.

Sett opp nettverk, sett opp database, installer RabbitMQ og nova* (nova-compute nova-volume nova-vncproxy nova-api nova-ajax-console-proxy nova-cert nova-consoleauth nova-doc nova-scheduler nova-network), sett opp /etc/nova/nova.conf, lag nettverk via nova-manage, lag credentilals.

På compute-noder er nova-network og nova-compute et krav, samt /etc/nova/nova.conf som peker til controlleren og hvor de andre tjenestene kjører (RabbitMQ o.l.).

Horizon
********

Når compute og controller er installert kan webgrensesnittet og nødvendige pakker installeres:

::

  sudo apt-get install libapache2-mod-wsgi openstack-dashboard.

Database må settes opp og synces. Webgrensesnittet nås via en webleser på ip-addressen til maskina det ble installert på, og for å logge inn brukes brukernavn og passord som ble satt opp tidligere i Keystone.

Infrastruktur
**************

Konfigurasjon
**************

Utvikling
----------

Scrum
******

django, python tutorials

Metode
*******

django, python tutorials


.. raw:: pdf

  PageBreak

Konklusjon (3-8 sider)
#######################

.. role:: rubric

:rubric:`De slutninger som kan trekkes fra resultatene og deres diskusjon skal være logisk og nøkternt oppbygd. Etterrettelighet er vesentlig. Konklusjoner skal fremkomme klart og uten tvetydigheter. Eventuell usikkerhet påpekes. Grunnlaget for slik tvil skal redegjøres under kapittel 6a/6b. De viktigste konklusjoner blir presentert i kortfattet versjon under ”Sammendrag”. Prosjektgruppen bør ta stilling til hva de faglige resultatene kan brukes til, hva gruppen faglig har lært av dette arbeidet, hva som evt. kunne vært gjort annerledes ved en gjentagelse av utviklingsarbeidet, og hvordan eventuelt videre arbeid rundt samme eller beslektet tema bør gjøres. Gruppen bør også kommentere den subjektive opplevelse av hovedprosjektet, og hvordan gruppeprosessen har vært. Kort sagt: Egenevaluering av gruppearbeidet.`

Diskusjon av resulater
-----------------------

Alternativer/muligheter/valg underveis
---------------------------------------

Kritikk av oppgaven
--------------------

Videre arbeid, ny(e) bacheloroppgaver
--------------------------------------

Evaluering av gruppens arbeid
------------------------------

Konklusjon
-----------

.. raw:: pdf

  PageBreak


Underskrift
############

.. role:: rubric

:rubric:`Etter konklusjonen skal underskrift med dato komme. Dersom rapporten inneholder ”Forord” skal underskriften komme der.`

Litteraturliste og referanser
##############################

.. role:: rubric

:rubric:`I rapporten skal det henvises til benyttet litteratur, særlig i kapittel 2. Henvisningene i rapportteksten gis som tallreferanse (Vancouver), og tilsvarende tall brukes i litteraturlisten. Litteraturen skal beskrives ved forfatternavn, boktittel, forlag, utgivelsessted og årstall.`

  - *Sitert fra, relevant støtte-/bakgrunnsstoff)*
  - *URL som fotnote?*
  - *Nummersystemet, Vancouver - ikke Harvard*
  
    - *“Bech-Karlsen [2] er en person vi bruker som eksempel. Han [2] er en kul kar.*
    - *[2] J. Bech-Karlsen, Gode Fagtekster. Oslo: Universitetsforlage, 2003*
    - *Hvem, hva, hvor, når*

¹ http://www.edugeek.net/forums/nix/8907-howto-using-802-1q-vlans-directly-linux.html  14.03.12
² http://manpages.ubuntu.com/manpages/natty/man8/dhcp-helper.8.html  14.03.12
³ http://ubuntuforums.org/showthread.php?t=716192  14.03.12
Cisco CCNA Exploration 4.0 LAN Switching & Wireless, kap 3 VLANs
Cisco CCNA Exploration 4.0 LAN Switching & Wireless, kap 6 Inter-VLAN routing
Cisco CCNA Exploration 4.0 Accessing the WAN, kap 7.1 DHCP  
⁴ http://blogs.cisco.com/datacenter/digging-deeper-into-vxlan/ 14.03.12
http://blogs.cisco.com/datacenter/introducing-vxlan/ 14.03.12
http://blogs.cisco.com/openatcisco/integrating-vxlan-in-openstack-quantum/ 14.03.12
http://docs.openstack.org/trunk/openstack-compute/admin/content/ 23.04.12
http://www.rabbitmq.com/tutorials/amqp-concepts.html 23.04.12
https://github.com/openstack/nova/tree/master/nova/scheduler 23.04.12
http://docs.openstack.org/incubation/openstack-network/admin/content/Preface-d1e71.html 24.04.12
http://wiki.openstack.org/Melange 24.04.12
http://www.slideshare.net/troytoman/openstack-folsom-summit-melange-overview 24.04.12
https://blueprints.launchpad.net/nova/+spec/network-refactoring 24.04.12


.. raw:: pdf

  PageBreak

Vedlegg
########

.. role:: rubric

:rubric:`Vedleggene nummereres, og vedlegg med flere sider skal sidenummeres. Alle vedlegg føres opp i innholdsfortegnelsen. Eksempler på innhold i vedlegg er tabeller, diagrammer, detaljskisser, koblingsskjemaer, designskjemaer, kalibreringskurver, observasjonsdata, utskrifter, komplette beregningseksempler, kode, dataprogrammer og disketter.`

  - *Definisjoner (av ulike ord/uttrykk)*

    - *Eks “tenant”*
  - *Fremdriftsplan, Gantt-diagram, milepæler, ansvarskart*
  - *Logg, møtereferat, statusrapporter*
  - *Designskjemaer*
  - *Kode (Eksempler?)*
  - *Mini-poster(?)*
  - *Kontrakten (m/oppdragsgiver)?*
  - *Stavekontroll*
  - *NB: FIGURER og TABELLER (nummerering, kildehenvisning)*
  - *Sidenummer (Kapittel 1 starter på side 1)*
  - *Topp/bunntekster?*
  - *Hva hadde vi planlagt, hvordan ble det*

Liste over figurer
-------------------

.. figure:: forsideboks.png

   Figur 1: Forsideboks

.. figure:: ukeplan.png

   Figur 2: Ukeplan

.. figure:: brukermiljo.png

   Figure 3: Brukermiljø

.. figure:: arkitektur.png
   :scale: 300%

   Figur 4: Arkitektur


Liste over tabeller
--------------------

.. csv-table:: Tabell 1: Sammendrag av bacheloroppgave
   :widths: 15,50  

   "**Tittel:**", "SkyHiGh Adm      **Nr: - Dato: 24.05.12**"
   "**Deltaker(e)**", "Lars Erik Pedersen, Jon Arne Westgaard, Hallvard Westman"
   "**Veileder(e):**", "Hanno Langweg, Høgskolen i Gjøvik"
   "**Oppdragsgiver:**", "Erik Hjelmås, Høgskolen i Gjøvik"
   "**Kontaktperson:**", ""
   "**Stikkord (4stk):**", "sky, virtualisering, pupp"
   "**Antall Sider:**", "**Antall bilag:** **Tilgjengelighet (åpen/konfidensiell):** Åpen"
   "**Kort beskrivelse av bacheloroppgaven:**", "Sette opp en skalerbar sky-tjeneste til bruk i undervisning på HiG"


.. csv-table:: Tabell 2: Summary of Graduate Project
   :widths: 15,50  

   "**Title:**", "SkyHiGh Adm      **Nr: - Dato: 24.05.12**"
   "**Participants**", "Lars Erik Pedersen, Jon Arne Westgaard, Hallvard Westman"
   "**Supervisor:**", "Hanno Langweg, Høgskolen i Gjøvik"
   "**Employer:**", "Erik Hjelmås, Høgskolen i Gjøvik"
   "**Contact person:**", ""
   "**Keywords:**", "sky, virtualisering, pupp"
   "**Pages:**", "**Antall bilag:** **Tilgjengelighet (åpen/konfidensiell):** Åpen"
   "**Short description of the main project:**", "Sette opp en skalerbar sky-tjeneste til bruk i undervisning på HiG"


.. csv-table:: Tabell 3: Risikoanalyse
   :header: "**Beskrivelse**","**Sannsynlighet**","**Konsekvens**"

   "Langtids sykdom", "Lav", "Ressursmangel, innsnevring av oppgave, avskjedigelse"
   "Datatap", "Lav", "Dobbeltarbeid"
   "Mangel på kompetanse", "Middels", "Løsninger som ikke følger best practice"
   "Dårlige tidsestimater", "Høy", "Ikke overholde interne frister"
   "Ødeleggende endringer", "Middels", "Ødelegge allerede fungerende moduler"


.. csv-table:: Tabell 4: Stabilitet og ytelse
      
   "**Problem med**", "Stabilitets- og ytelsesproblemer, ingen lastbalansering eller skalering"
   "**Berører**", "Alle brukere, administrator"
   "**Som resultat av dette**", "Tar lang tid å kjøre kommandoer, de virtuelle maskinene “henger” innimellom, tidvis dårlig tidsutnyttelse i lab-timer. Da man ikke kan koble opp flere noder/servere på systemet vil man ikke kunne skalere systemet opp fra x antall brukere til y antall brukere uten å kjøpe en helt ny maskin"
   "**En vellykket løsning vil**", "Gjennom bedre skalerbarhet og lastbalansering sørge for at de virtuelle maskinene ikke opplever ytelsesproblemer ved å la administrator koble opp flere noder/servere på systemet."


.. csv-table:: Tabell 5: Manuell administrering
      
   "**Problem med**", "Manuell administrering av hver enkelt VM"
   "**Berører**", "Administrator, brukere"
   "**Som resultat av dette**", "Hver enkelt student som har en/flere vm´er må be om at administrator skal utføre enkle oppgaver som de egentlig burde kunne gjort selv. Rett og slett Livs-syklusen til en VM."
   "**En vellykket løsning vil**", "La brukere administrere sin egen/egne vm’ers livs-syklus alt etter hvilket rettigheter administrator har gitt dem."


.. csv-table:: Tabell 6: Produktsammendrag 
      
   "**For**", "Erik Hjelmås"
   "**som**", "Har behov for et helt nytt system som er skreddersydd for hans behov"
   "**produktet navngitt**", "er en nettsky basert på OpenStack"
   "**som**", "- Lar seg administrere av brukere,
  - Skalere
  - Lastbalansere"
   "**i motsetning til**", "dagens system"
   "**Har vårt produkt**", "Løsningene på dagens problemer, i tillegg til nye krav satt av arbeidsgiver (se kravspesifikasjon)"


.. csv-table:: Tabell 7: Oppsummering av interessenter
   :header: "**Navn**", "**Utdypende beskrivelse**", "**Rolle under utviklingen**"

   "Erik Hjelmås", "Vil veilede den tekniske biten, sette krav i forhold til systemet (ikke bacheloroppgaven) ukentlig", "Arbeidsgiver"
   "Hanno Langweg", "Vil veilede ukentlig i forhold til Bacheloroppgaven", "Veileder"


.. csv-table:: Tabell 8: Oppsummering av brukere
   :header: "**Navn**", "**Utdypende beskrivelse**", "**Rolle under utviklingen**", "**Representert av**"

   "Student", "Studentene vil bruke denne tjenesten aktivt i undervisningen. Studenten er kunden som skal betjenes.", "Vil ikke ha noen rolle", "Lars Erik, Jon Arne og Hallvard"
   "Administrator", "Administratoren vil tilby og vedlikeholde nettskyen som en tjeneste for Studentene(se rolle ovenfor)", "Bruker av systemet", "Erik Hjelmås"


.. csv-table:: Tabell 9: Routere
   :header: "**Enhet, modell**", "**Nettverkskort**", "**MAC-adresse**", "**IP/Mask**", "**Gateway**"
   
   "Brighton, HP ProLiant DL320", "eth0", "00:1f:29:13:02:8a", "DHCP", " "
   "", "eth1", "00:1f:29:13:02:8b", "10.0.0.1/30", "10.0.0.2"
   "SkyRoute, Cisco 2800", "fa0/0", "ec:44:76:68:16:94", "10.0.0.2/30", ""
   "", "fa0/1", "ec:44:76:68:16:95", "192.168.99.1/24", ""
   "", "fa0/1.10", "''", "192.168.10.1/24", ""
   "", "fa0/1.20", "''", "192.168.20.1/24", ""
   "", "fa0/1.30", "''", "192.168.30.1/24", ""


.. csv-table:: Tabell 10: Switch
   :header: "**Enhet, modell, Management IP**", "**Port**", "**Hastighet**", "**VLAN(s)**", "**Trunk status**"
   :widths: 25, 15, 15, 20, 10  

   "switchd13d24, Cisco SG-200 26, 192.168.99.254/24", "GE1-12", "1000Mbit", "10 (public)", "av"
   "", "GE13-18", "1000mbit", "100-115 (VLAN for VM'er)", "på"
   "", "GE19-24", "1000mbit", "30 (storage)", "av"
   "", "GE25", "1000Mbit", "99 (native/management)", "av"
   "", "GE26", "1000Mbit", "10, 20, 30, 99", "på"


.. csv-table:: Tabell 11: Servere
   :header: "**Navn**", "**CPU**", "**RAM**", "**Disk**", "**IP**"

   "dublin", "Intel Xeon 3060 2.4 GHz", "4GiB", "2 x 250 GB", "eth0: 192.168.10.2, eth1: oppe - ingen IP, eth3: 192.168.30.2"
   "manchester", "Intel Xeon 3060 2.4 GHz", "4GB", "2 x 250 GB", "eth0: 192.168.20.10, eth1: ioppe - ingen IP"
   "newcastle", "Intel Xeon 3060 2.4 GHz", "2GiB", "2 x 250 GB", "eth0: 192.168.20.12, eth1: oppe - ingen IP"
   "cardiff", "Intel Xeon 3060 2.4 GHz", "2GiB", "2 x 250 GB", "eth0: 192.168.20.11, eth1: oppe - ingen IP"
   "kingston", "", "", "12 x 250 GB", "eth0: 192.168.30.20"


Product backlog
----------------

Arbeidslogg
------------

Møtelogg
---------

Grupperegler
-------------

Kildekode
----------


