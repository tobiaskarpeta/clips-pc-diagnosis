; Hodne jednoduchy expertni system pro diagnostiku problemu s pocitacem
; Autor: Bc. Tobias Karpeta (KAR0243)
; Predmet: Aplikovana umela inteligence

; Sablony
(deftemplate symptom
   (slot nazev)
   (slot pritomen (default ne)))

(deftemplate diagnosis
   (slot nazev))

; Osetreni uzivatelskeho vstupu na ano/ne
(deffunction read-ano-ne ()
  (bind ?odpoved (lowcase (read)))
  (if (or (eq ?odpoved ano) (eq ?odpoved ne))
      then ?odpoved
      else
        (printout t "Zadej prosim pouze 'ano' nebo 'ne': ")
        (return (read-ano-ne))
  )
)

; Dotazovaci pravidla
(defrule ask-power-on
   (declare (salience 27))
   (not (symptom (nazev power-on)))
   (not (diagnosis))
   =>
   (printout t "Zapne se pocitac? (ano/ne): ")
   (bind ?odpoved (read-ano-ne))
   (assert (symptom (nazev power-on) (pritomen ?odpoved))))

(defrule ask-beeps
   (declare (salience 25))
   (not (symptom (nazev beeps)))
   (not (diagnosis))
   =>
   (printout t "Ozyva se pipnuti pri startu? (ano/ne): ")
   (bind ?odpoved (read-ano-ne))
   (assert (symptom (nazev beeps) (pritomen ?odpoved))))

(defrule ask-screen-works
   (declare (salience 23))
   (not (symptom (nazev screen-works)))
   (not (diagnosis))
   =>
   (printout t "Zobrazi se neco na obrazovce? (ano/ne): ")
   (bind ?odpoved (read-ano-ne))
   (assert (symptom (nazev screen-works) (pritomen ?odpoved))))

(defrule ask-boot-loop
   (declare (salience 21))
   (not (symptom (nazev boot-loop)))
   (not (diagnosis))
   =>
   (printout t "Restartuje se pocitac neustale dokola? (ano/ne): ")
   (bind ?odpoved (read-ano-ne))
   (assert (symptom (nazev boot-loop) (pritomen ?odpoved))))

(defrule ask-overheating
   (declare (salience 19))
   (not (symptom (nazev overheating)))
   (not (diagnosis))
   =>
   (printout t "Prehriva se pocitac? (ano/ne): ")
   (bind ?odpoved (read-ano-ne))
   (assert (symptom (nazev overheating) (pritomen ?odpoved))))

(defrule ask-fan-noise
   (declare (salience 18))
   (symptom (nazev overheating) (pritomen ano))
   (not (symptom (nazev fan-noise)))
   (not (diagnosis))
   =>
   (printout t "Je slyset vetrak? (ano/ne): ")
   (bind ?odpoved (read-ano-ne))
   (assert (symptom (nazev fan-noise) (pritomen ?odpoved))))

(defrule ask-os-error
   (declare (salience 15))
   (not (symptom (nazev os-error)))
   (not (diagnosis))
   =>
   (printout t "Hlasi system chybu pri spusteni? (ano/ne): ")
   (bind ?odpoved (read-ano-ne))
   (assert (symptom (nazev os-error) (pritomen ?odpoved))))

(defrule ask-bios
   (declare (salience 13))
   (not (symptom (nazev bios)))
   (not (diagnosis))
   =>
   (printout t "Najizdi pocitac do BIOSu? (ano/ne): ")
   (bind ?odpoved (read-ano-ne))
   (assert (symptom (nazev bios) (pritomen ?odpoved))))

(defrule ask-usb
   (declare (salience 11))
   (not (symptom (nazev usb)))
   (not (diagnosis))
   =>
   (printout t "Funguje ti mys a klavesnice? (ano/ne): ")
   (bind ?odpoved (read-ano-ne))
   (assert (symptom (nazev usb) (pritomen ?odpoved))))

(defrule ask-network
   (declare (salience 9))
   (not (symptom (nazev network)))
   (not (diagnosis))
   =>
   (printout t "Jede ti internet / komunikace v siti? (ano/ne): ")
   (bind ?odpoved (read-ano-ne))
   (assert (symptom (nazev network) (pritomen ?odpoved))))

(defrule ask-virus
   (declare (salience 7))
   (not (symptom (nazev virus)))
   (not (diagnosis))
   =>
   (printout t "Zpomalil se ti pocitac nebo se zacal chovat jinak? (ano/ne): ")
   (bind ?odpoved (read-ano-ne))
   (assert (symptom (nazev virus) (pritomen ?odpoved))))

(defrule ask-sound
   (declare (salience 5))
   (not (symptom (nazev no-sound)))
   (not (diagnosis))
   =>
   (printout t "Slysis zvuky ze systemu? (ano/ne): ")
   (bind ?odpoved (read-ano-ne))
   (assert (symptom (nazev no-sound) (pritomen ?odpoved))))

; Diagnosticka pravidla

(defrule diagnose-power-supply
   (declare (salience 26))
   (symptom (nazev power-on) (pritomen ne))
   (not (diagnosis))
   =>
   (assert (diagnosis (nazev "Vadny zdroj napajeni")))
   (printout t crlf "Diagnoza: Vadny zdroj napajeni" crlf)
   (halt))

(defrule diagnose-ram
   (declare (salience 24))
   (symptom (nazev beeps) (pritomen ano))
   (not (diagnosis))
   =>
   (assert (diagnosis (nazev "Vadna pamet RAM")))
   (printout t crlf "Diagnoza: Vadna pamet RAM" crlf)
   (halt))

(defrule diagnose-display
   (declare (salience 22))
   (symptom (nazev screen-works) (pritomen ne))
   (not (diagnosis))
   =>
   (assert (diagnosis (nazev "Vadna graficka karta nebo monitor")))
   (printout t crlf "Diagnoza: Vadna graficka karta nebo monitor" crlf)
   (halt))

(defrule diagnose-boot-loop
   (declare (salience 20))
   (symptom (nazev boot-loop) (pritomen ano))
   (not (diagnosis))
   =>
   (assert (diagnosis (nazev "Chyba bootovani - zkontrolujte hardware, BIOS nebo aktualizace")))
   (printout t crlf "Diagnoza: Chyba bootovani - zkontrolujte hardware, BIOS nebo aktualizace" crlf)
   (halt))

(defrule diagnose-overheating-with-fan
   (declare (salience 17))
   (symptom (nazev overheating) (pritomen ano))
   (symptom (nazev fan-noise) (pritomen ano))
   (not (diagnosis))
   =>
   (assert (diagnosis (nazev "Nedostacujici chlazeni")))
   (printout t crlf "Diagnoza: Nedostacujici chlazeni" crlf)
   (halt))

(defrule diagnose-overheating-without-fan
   (declare (salience 16))
   (symptom (nazev overheating) (pritomen ano))
   (symptom (nazev fan-noise) (pritomen ne))
   (not (diagnosis))
   =>
   (assert (diagnosis (nazev "Nezapojene/vadne chlazeni")))
   (printout t crlf "Diagnoza: Nezapojene/vadne chlazeni" crlf)
   (halt))

(defrule diagnose-hdd
   (declare (salience 14))
   (symptom (nazev os-error) (pritomen ano))
   (not (diagnosis))
   =>
   (assert (diagnosis (nazev "Vadny pevny disk")))
   (printout t crlf "Diagnoza: Vadny pevny disk" crlf)
   (halt))

(defrule diagnose-bios
   (declare (salience 12))
   (symptom (nazev bios) (pritomen ano))
   (not (diagnosis))
   =>
   (assert (diagnosis (nazev "Chyba BIOSu/Nenainstalovany OS")))
   (printout t crlf "Diagnoza: Chyba BIOSu / Neexistujici instalace OS." crlf)
   (halt))

(defrule diagnose-usb
   (declare (salience 10))
   (symptom (nazev usb) (pritomen ne))
   (not (diagnosis))
   =>
   (assert (diagnosis (nazev "Vadny USB port")))
   (printout t crlf "Diagnoza: Vadny USB port" crlf)
   (halt))

(defrule diagnose-network
   (declare (salience 8))
   (symptom (nazev network) (pritomen ne))
   (not (diagnosis))
   =>
   (assert (diagnosis (nazev "Vadny sitovy adapter")))
   (printout t crlf "Diagnoza: Vadny sitovy adapter" crlf)
   (halt))

(defrule diagnose-virus
   (declare (salience 6))
   (symptom (nazev virus) (pritomen ano))
   (not (diagnosis))
   =>
   (assert (diagnosis (nazev "Virus")))
   (printout t crlf "Diagnoza: Pocitac infikovany virem" crlf)
   (halt))

(defrule diagnose-no-sound
   (declare (salience 4))
   (symptom (nazev no-sound) (pritomen ne))
   (not (diagnosis))
   =>
   (assert (diagnosis (nazev "Spatna zvukova karta/driver")))
   (printout t crlf "Diagnoza: Spatna zvukova karta nebo chybejici/spatny ovladac" crlf)
   (halt))

(defrule diagnose-no-issue
   (declare (salience 1))
   (not (diagnosis))
   =>
   (assert (diagnosis (nazev "Nenalezen problem")))
   (printout t crlf "Nenalezen zadny problem." crlf)
   (halt))