(in-package :mu-cl-resources)

;;;;
;; NOTE
;; docker-compose stop; docker-compose rm; docker-compose up
;; after altering this file.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; KLACHTENFORMULEIR ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-resource klachtformulier ()
  :class (s-prefix "ext:ComplaintForm")

  :properties `((:name :string ,(s-prefix "foaf:name"))
                (:contact-person-name ,(s-prefix "foaf:Person.name"))
                (:street ,(s-prefix "schema:streetAddress"))
                (:house-number ,(s-prefix "schema:postOfficeBoxNumber"))
                (:address-complement ,(s-prefix "ext:addressComplement"))
                (:locality :string ,(s-prefix "schema:addressLocality"))
                (:postal-code :string ,(s-prefix "schema:postalCode"))
                (:telephone :string ,(s-prefix "schema:telephone"))
                (:email :string ,(s-prefix "schema:email"))
                (:content :string ,(s-prefix "ext:content"))

  :has-many `((file :via ,(s-prefix "nmo:hasAttachment")
                    :as "attachments"))

  :resource-base (s-url "http://data.notable.redpencil.io/editor-documents/")

  :on-path "klachtenformulier")

(define-resource file ()
  :class (s-prefix "nfo:FileDataObject")
  :properties `((:filename :string ,(s-prefix "nfo:fileName"))
                (:format :string ,(s-prefix "dct:format"))
                (:size :number ,(s-prefix "nfo:fileSize"))
                (:extension :string ,(s-prefix "dbpedia:fileExtension"))
                (:created :datetime ,(s-prefix "nfo:fileCreated")))
  :has-one `((file :via ,(s-prefix "nie:dataSource")
                   :inverse t
                   :as "download"))
  :resource-base (s-url "http://data.lblod.info/files/")
  :features `(no-pagination-defaults include-uri)
  :on-path "files")

(define-resource file-address ()
  :class (s-prefix "ext:FileAddress")
  :properties `((:address :url ,(s-prefix "ext:fileAddress")))
  :resource-base (s-url "http://data.lblod.info/file-addresses/")
  :features `(no-pagination-defaults include-uri)
  :on-path "file-addresses")
