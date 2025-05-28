(define-resource user ()
  :class (s-prefix "foaf:Person")
  :resource-base (s-url "http://data.lblod.info/id/user/")
  :properties `((:first-name :string ,(s-prefix "foaf:firstName"))
                (:family-name :string ,(s-prefix "foaf:familyName")))
  :has-many `((account :via ,(s-prefix "foaf:account")
                       :as "account")
              (administrative-unit :via ,(s-prefix "foaf:member")
                              :as "groups"))
  :on-path "users"
)

(define-resource account ()
  :class (s-prefix "foaf:OnlineAccount")
  :resource-base (s-url "http://data.lblod.info/id/account/")
  :properties `((:provider :via ,(s-prefix "foaf:accountServiceHomepage"))
                (:roles :string-set ,(s-prefix "ext:sessionRole"))
                (:vo-id :via ,(s-prefix "dct:identifier")))
  :has-one `((user :via ,(s-prefix "foaf:account")
                         :inverse t
                         :as "user"))
  :on-path "accounts"
)

(define-resource administrative-unit ()
  :class (s-prefix "besluit:Bestuurseenheid")
  :properties `((:name :string ,(s-prefix "skos:prefLabel"))
                (:alternative-name :string-set ,(s-prefix "skos:altLabel")))

  :resource-base (s-url "http://data.lblod.info/id/bestuurseenheden/")
  :on-path "administrative-units"
)
