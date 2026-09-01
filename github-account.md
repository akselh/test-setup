# GitHub-konto og tilgang til bedriftens GitHub-organisasjon

I workshopen henter du AI verktøy m.m. fra et repository (kode-prosjekt) i din bedrifts
GitHub-organisasjon. Du trenger en GitHub-konto, og GitHub-admin i bedriften må legge
deg til i organisasjonen.

Denne guiden tar tid hos andre enn deg, så start med den.

1. Har du allerede en GitHub-konto? Da hopper du til punkt 3.
2. Lag en privat GitHub-konto på https://github.com/signup.
   - Du kan fritt velge brukernavn på GitHub. Disse er som regel ganske korte, fint med noe som har
     med eks. fornavnet ditt.
   - Legg også inn ditt fulle navn på kontoen.
   - Du bør bruke privat e-postadresse. Dette for fortsatt tilgang til kontoen ved evt. skifte av arbeidsgiver.
3. Slå på tofaktor (2FA). GitHub krever det av alle brukere, men spør deg ikke om det
   selv — du må gå dit på egen hånd:
   - Gå rett til https://github.com/settings/security. (Samme sted via menyen: klikk
     profilbildet ditt øverst til høyre, velg **Settings**, så **Password and
     authentication** i venstremenyen.)
   - Klikk **Enable two-factor authentication**. GitHub viser en QR-kode.
   - Skann QR-koden med en autentiseringsapp på telefonen, for eksempel Microsoft
     Authenticator.
   - **Bruker du en passordbehandler**, for eksempel 1Password? Da kan den sprette opp
     med «Save one-time password?» når QR-koden vises. Det er helt i orden — klikk
     **Save** der, så er passordbehandleren autentiseringsappen din, og du trenger
     ingen app på telefonen.
   - Skriv den sekssifrede koden fra appen (eller passordbehandleren) i feltet «Verify
     the code from the app», og klikk **Save**. Først da er tofaktor på.
   - Ta vare på gjenopprettingskodene GitHub gir deg til slutt. Uten dem kan du miste
     kontoen.
4. Send GitHub-brukernavnet ditt til GitHub-administrator i din bedrift.
5. Administrator inviterer deg til bedriftens GitHub-konto (organisasjonen). Du får en e-post fra GitHub.
   Åpne e-posten og klikk **Join** for å godta invitasjonen.

Innloggingen på GitHub fra maskinen din skjer under
[sjekken etter installasjon](check-installation.md), etter at du har fulgt
[installation-guide.md](installation-guide.md).
