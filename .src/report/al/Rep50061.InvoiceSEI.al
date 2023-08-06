report 50061 "Invoice SEI"
{
    Caption = 'Invoice SEI', Locked = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/Rep50061.InvoiceSEI.rdlc';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(VendorName; Name) { }
            column(VendorAddress; Address) { }
            column(VendorAddress_2; "Address 2") { }
            column(VendorCity; City) { }
            column(VendorPost_Code; "Post Code") { }
            column(VendorVAT_Registration_No_; "VAT Registration No.") { }
            column(VendorEU_VAT_Registration_No_; "HUNLOC EU VAT Registration No.") { }
            column(VendorBank_Name; "Bank Name") { }
            column(VendorBank_Account_No_; "Bank Account No.") { }
            column(VendorSWIFT_Code; "SWIFT Code") { }
            column(VendorIBAN; IBAN) { }
            column(VendorPicture; Picture) { }
            column(VendorCounty; County) { }
            column(VendorCountry2; GetCountryName("Country/Region Code")) { }

            trigger OnAfterGetRecord()
            begin

            end;
        } // company information
        dataitem("Sales Header"; "Sales Invoice Header")
        {
            //RequestFilterFields = "No.";
            //DataItemTableView = where("Document Type" = filter(= Invoice));
            //column(SalesHeaderKeyDocument_Type; "Document Type") { }
            column(SalesHeaderKeyInvoiceNo_; "No.") { }
            column(BuyerBill_to_Name; "Bill-to Name") { }
            column(BuyerBill_to_Address; "Bill-to Address") { }
            column(BuyerBill_to_Address_2; "Bill-to Address 2") { }
            column(BuyerBill_to_City; "Bill-to City") { }
            column(BuyerBill_to_Post_Code; "Bill-to Post Code") { }
            column(BuyerBill_to_Country_Region_Code; "Bill-to Country/Region Code") { }
            column(BuyerVAT_Registration_No_; "VAT Registration No.") { }
            column(Buyer_EU_VAT_Registration_No_; "HUNLOC EU VAT Registration No.") { }
            column(BuyerShip_to_Name; "Ship-to Name") { }
            column(BuyerShip_to_Address; "Ship-to Address") { }
            column(BuyerShip_to_Address_2; "Ship-to Address 2") { }
            column(BuyerShip_to_City; "Ship-to City") { }
            column(BuyerShip_to_County; "Ship-to County") { }
            column(BuyerShip_to_Post_Code; "Ship-to Post Code") { }
            column(FulfillmentDate; "Shipment Date") { }
            column(DateOfInvoice; "Document Date") { }
            column(DueDate; "Due Date") { }
            column(Payment_Method_Code; "Payment Method Code") { }
            column(BillToCountryName2; GetCountryName("Bill-to Country/Region Code")) { }
            column(BuyerShipToCountryName; GetCountryName("Ship-to Country/Region Code")) { }
            column(CurrencyCode; GetCurrencyCode("Currency Code")) { }
            column(Prices_Including_VAT; "Prices Including VAT") { }

            dataitem("Sales Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(SalesLineKeyDocument_No_; "Document No.") { }
                //column(SalesLineKeyDocument_Type; "Document Type") { }
                column(SalesLineKeyLine_No_; "Line No.") { }
                column(SalesLineItemNo; "No.") { }
                column(SalesLineQuantity; Quantity) { }
                column(SalesLineUnitPrice; "Unit Price") { }
                column(SalesLineNetAmount; Amount) { }
                column(SalesLineAmount_Including_VAT; "Amount Including VAT") { }
                column(SalesLineVATPercent; "VAT %") { }
                column(SalesLine_VAT_Amount__VCY_; "HUNLOC VAT Amount (VCY)") { }
                column(SalesLineItemDescription; Description) { }
                column(SalesLineUnitCode; "Unit of Measure Code") { }
                column(SalesLineCustomerItemNo; "Item Reference No.") { }
                column(SalesLineOrderNo; "Order No.") { }
                column(HUNLOC_Tariff_No_; "HUNLOC Tariff No.") { }
                column(Shipment_Date; "Shipment Date") { }
                column(HUNLOC_VAT_Currency_Factor; "HUNLOC VAT Currency Factor") { }
                column(summVatValue; summVatValue("HUNLOC VAT Amount (VCY)")) { }
                column(VAT_Prod__Posting_Group; "VAT Prod. Posting Group") { }
                column(isVat; isVat("HUNLOC VAT Amount (VCY)")) { }

                dataitem("Posted Whse. Shipment Line"; "Posted Whse. Shipment Line")
                {
                    DataItemLink = "Source No." = field("Order No.");
                    column(SalesShipmentLineDocument_No_; "Whse. Shipment No.") { }

                    trigger OnPreDataItem()
                    begin
                        "Posted Whse. Shipment Line".SetFilter("Source No.", "Sales Line"."Order No.");
                        "Posted Whse. Shipment Line".SetFilter("Shipment Date", format("Sales Line"."Shipment Date"));
                        "Posted Whse. Shipment Line".SetFilter("Item No.", "Sales Line"."No.");
                        "Posted Whse. Shipment Line".SetFilter(Quantity, format("Sales Line".Quantity));
                        //Logikai hibája van, ha egy napon ugyanarról az eladási rendelésről szállítunk több szállítmány és a mennyiség is egyezik akkor nem lesz
                        //jó a whse shipment nr. Nem lehet összekötni a 2 táblát, mert az invoice csak a rendelési számot tartalmazza, a szállítási doksiét nem.

                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    "Sales Line".SetRange("Document No.", InvoiceNumber);
                    //"Sales Line".SetRange("Document No.", "No.");
                end;

            }// sales line

            trigger OnPreDataItem()
            begin
                "Sales Header".SetRange("No.", InvoiceNumber);
                //"Sales Header".SetRange("No.", "No.");
            end;

            trigger OnAfterGetRecord()
            begin

            end;


        }// sales header
    } // dataset

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    Caption = 'Setup', Locked = true;
                    field(InvoiceNumber; InvoiceNumber)
                    {
                        ApplicationArea = All;
                        Caption = 'Invoice number', Locked = true;
                        TableRelation = "Sales Invoice Header"."No."; // választási lehetőség megjelenítése
                    }

                }
            }
        }

        actions
        {
            area(processing)
            {
            }
        }

        trigger OnOpenPage()
        begin
            //"Sales Invoice Header".SetRange("No.", InvoiceNumber);
        end;
    } // requestpage

    labels
    {
        LblTitle = 'INVOICE / SZÁMLA', Locked = true;
        LblVendorName = 'VENDOR DATA / Szállító adatai :', Locked = true;
        LblVendorTaxNumber = 'TAX ID (VAT) NUMBER / Adószám :', Locked = true;
        LblVendorEUTaxNumber = 'EU TAX ID (VAT) NUMBER / Adószám :', Locked = true;
        LblVendorBankName = 'BANK NAME / Bank :', Locked = true;
        LblVendorBankAccount = 'BANK ACCOUNT / Bankszámla', Locked = true;
        LblVendorSwiftCode = 'SWIFT CODE / SWIFT kód :', Locked = true;
        LblVendorIbanCode = 'IBAN CODE / IBAN kód :', Locked = true;

        LblBuyerData = 'BUYER DATA / Vevő adatai :', Locked = true;
        LblBuyerTaxNumber = 'TAX ID (VAT) NUMBER / Adószám :', Locked = true;
        LblBuyerEUTaxNumber = 'EU TAX ID (VAT) NUMBER / Adószám :', Locked = true;

        LblShipToCustomerData = 'SHIP-TO CUSTOMER / Szállítási cím :', Locked = true;
        LblShipToCustomerEUTaxNumber = 'EU TAX ID (VAT) NUMBER / Adószám :', Locked = true;

        LblFulfillmentDate = 'FULFILLMENT DATE / Teljesítés ideje :', Locked = true;
        LblDateOfInvoice = 'DATE OF INVOICE / Számla kelte :', Locked = true;
        LblDueDate = 'DUE DATE / Fizetési határidő :', Locked = true;
        LblPaymentMethod = 'PAYMENT METHOD / Fizetési mód :', Locked = true;
        LblInvoiceNumber = 'INVOICE NUMBER / Számlaszám :', Locked = true;

        LblOrderNumber = 'Order No. / Rendelés száma :', Locked = true;
        LblExternalDocNo = 'External doc. No. / Külső biz. szám :', Locked = true;

        LblItemNo = 'Item No. / Cikkszám', Locked = true;
        LblCustItemNo = 'Cust. code / Vevői cikkszám :', Locked = true;
        LblItemDescription = 'Description / Megnevezés', Locked = true;
        LblCoSZO = 'C.O./SZ.O.', Locked = true;
        LblQty = 'Quantity / Mennyiség', Locked = true;
        LblUnitCode = 'U.O.M. / M. e.', Locked = true;
        LblUnitPrice = 'Unit Price / Egységár', Locked = true;
        LblNetPrice = 'Net. price / Nettó ár', Locked = true;
        LblVAT = 'VAT% / ÁFA%', Locked = true;
        LblVatAmount = 'VAT amount / ÁFA összeg', Locked = true;
        LblTotalPrice = 'Total price / Teljes ár', Locked = true;
        LblTarrifNo = 'Tarrif No. :', Locked = true;
        LblShipment = 'Shipment', Locked = true;
        LblWarehouseShipment = 'Warehouse shipment', Locked = true;
        LblPage = 'Page :', Locked = true;
        LblTariff = 'Tariff No.:', Locked = true;
        LblTotals = 'Tolal / Összesen :', Locked = true;

        LblFootnote = 'This document complies with the requirements of PM 24/1995 (XI.22.) / A bizonylat megfelel a PM 24/1995 (XI.22.) rendeletnek', Locked = true;
        LblCurrency = 'CURRENCY / Pénznem :', Locked = true;
        LblVatBaseAmount = 'Base Amount / Alapösszeg', Locked = true;
        LblVatBaseAmountHuf = 'Base Amount HUF / Alapösszeg HUF', Locked = true;
        LblVatVatAmountHuf = 'VAT Amount HUF / Áfa összege HUF', Locked = true;
        LblVatExchangeRate = 'Exchange rate / Árfolyam', Locked = true;
        LblVatDetails = 'VAT Details / ÁFA részletezve', Locked = true;


    } // label declaration

    var
        InvoiceNumber: Code[20];
        CurrencyCode: Code[10];

    procedure summVatValue(VatValue: Decimal): Decimal;
    var
        SumVat: Decimal;
    begin
        SumVat := SumVat + VatValue;
        exit(SumVat);
    end;

    procedure isVat(VatValue: Decimal): Boolean;
    begin
        if VatValue <> 0 then
            exit(true)
        else
            exit(false);
    end;

    procedure GetCurrencyCode(CurCode: Code[10]): Text;
    begin
        if "Sales Header"."Currency Code" = ''
        then begin
            CurrencyCode := 'EUR';
            exit(CurrencyCode);
        end
        else begin
            CurrencyCode := "Sales Header"."Currency Code";
            exit(CurrencyCode);
        end;

    end;


    procedure GetCountryName(CountryCode: Text[35]): Text;
    begin
        //if CountryCode = 'GB' then exit('Anglia')
        case CountryCode of
            'AF':
                exit('Afghanistan');
            'AL':
                exit('Albania');
            'DZ':
                exit('Algeria');
            'AS':
                exit('American Samoa');
            'AD':
                exit('Andorra');
            'AO':
                exit('Angola');
            'AI':
                exit('Anguilla');
            'AQ':
                exit('Antarctica');
            'AG':
                exit('Antigua and Barbuda');
            'AR':
                exit('Argentina');
            'AM':
                exit('Armenia');
            'AW':
                exit('Aruba');
            'AU':
                exit('Australia');
            'AT':
                exit('Austria');
            'AZ':
                exit('Azerbaijan');
            'BS':
                exit('Bahamas');
            'BH':
                exit('Bahrain');
            'BD':
                exit('Bangladesh');
            'BB':
                exit('Barbados');
            'BY':
                exit('Belarus');
            'BE':
                exit('Belgium');
            'BZ':
                exit('Belize');
            'BJ':
                exit('Benin');
            'BM':
                exit('Bermuda');
            'BT':
                exit('Bhutan');
            'BO':
                exit('Plurinational State of Bolivia');
            'BQ':
                exit('Bonaire, Sint Eustatius and Saba');
            'BA':
                exit('Bosnia and Herzegovina');
            'BW':
                exit('Botswana');
            'BV':
                exit('Bouvet Island');
            'BR':
                exit('Brazil');
            'IO':
                exit('British Indian Ocean Territory');
            'BN':
                exit('Brunei Darussalam');
            'BG':
                exit('Bulgaria');
            'BF':
                exit('Burkina Faso');
            'BI':
                exit('Burundi');
            'CV':
                exit('Cabo Verde');
            'KH':
                exit('Cambodia');
            'CM':
                exit('Cameroon');
            'CA':
                exit('Canada');
            'KY':
                exit('Cayman Islands');
            'CF':
                exit('Central African Republic');
            'TD':
                exit('Chad');
            'CL':
                exit('Chile');
            'CN':
                exit('China');
            'CX':
                exit('Christmas Island');
            'CC':
                exit('Cocos (Keeling) Islands');
            'CO':
                exit('Colombia');
            'KM':
                exit('Comoros');
            'CD':
                exit('The Democratic Republic of Congo');
            'CG':
                exit('Congo');
            'CK':
                exit('Cook Islands');
            'CR':
                exit('Costa Rica');
            'HR':
                exit('Croatia');
            'CU':
                exit('Cuba');
            'CW':
                exit('Curaçao');
            'CY':
                exit('Cyprus');
            'CZ':
                exit('Czechia');
            'CI':
                exit('Côte d Ivoire');
            'DK':
                exit('Denmark');
            'DJ':
                exit('Djibouti');
            'DM':
                exit('Dominica');
            'DO':
                exit('Dominican Republic');
            'EC':
                exit('Ecuador');
            'EG':
                exit('Egypt');
            'SV':
                exit('El Salvador');
            'GQ':
                exit('Equatorial Guinea');
            'ER':
                exit('Eritrea');
            'EE':
                exit('Estonia');
            'SZ':
                exit('Eswatini');
            'ET':
                exit('Ethiopia');
            'FK':
                exit('Falkland Islands [Malvinas]');
            'FO':
                exit('Faroe Islands');
            'FJ':
                exit('Fiji');
            'FI':
                exit('Finland');
            'FR':
                exit('France');
            'GF':
                exit('French Guiana');
            'PF':
                exit('French Polynesia');
            'TF':
                exit('French Southern Territories');
            'GA':
                exit('Gabon');
            'GM':
                exit('Gambia');
            'GE':
                exit('Georgia');
            'DE':
                exit('Germany');
            'GH':
                exit('Ghana');
            'GI':
                exit('Gibraltar');
            'GR':
                exit('Greece');
            'GL':
                exit('Greenland');
            'GD':
                exit('Grenada');
            'GP':
                exit('Guadeloupe');
            'GU':
                exit('Guam');
            'GT':
                exit('Guatemala');
            'GG':
                exit('Guernsey');
            'GN':
                exit('Guinea');
            'GW':
                exit('Guinea-Bissau');
            'GY':
                exit('Guyana');
            'HT':
                exit('Haiti');
            'HM':
                exit('Heard Island and McDonald Islands');
            'VA':
                exit('Holy See');
            'HN':
                exit('Honduras');
            'HK':
                exit('Hong Kong');
            'HU':
                exit('Hungary');
            'IS':
                exit('Iceland');
            'IN':
                exit('India');
            'ID':
                exit('Indonesia');
            'IR':
                exit('Islamic Republic of Iran');
            'IQ':
                exit('Iraq');
            'IE':
                exit('Ireland');
            'IM':
                exit('Isle of Man');
            'IL':
                exit('Israel');
            'IT':
                exit('Italy');
            'JM':
                exit('Jamaica');
            'JP':
                exit('Japan');
            'JE':
                exit('Jersey');
            'JO':
                exit('Jordan');
            'KZ':
                exit('Kazakhstan');
            'KE':
                exit('Kenya');
            'KI':
                exit('Kiribati');
            'KP':
                exit('The Democratic Peoples Republic of Korea');
            'KR':
                exit('The Republic of Korea');
            'KW':
                exit('Kuwait');
            'KG':
                exit('Kyrgyzstan');
            'LA':
                exit('Lao Peoples Democratic Republic');
            'LV':
                exit('Latvia');
            'LB':
                exit('Lebanon');
            'LS':
                exit('Lesotho');
            'LR':
                exit('Liberia');
            'LY':
                exit('Libya');
            'LI':
                exit('Liechtenstein');
            'LT':
                exit('Lithuania');
            'LU':
                exit('Luxembourg');
            'MO':
                exit('Macao');
            'MG':
                exit('Madagascar');
            'MW':
                exit('Malawi');
            'MY':
                exit('Malaysia');
            'MV':
                exit('Maldives');
            'ML':
                exit('Mali');
            'MT':
                exit('Malta');
            'MH':
                exit('Marshall Islands');
            'MQ':
                exit('Martinique');
            'MR':
                exit('Mauritania');
            'MU':
                exit('Mauritius');
            'YT':
                exit('Mayotte');
            'MX':
                exit('Mexico');
            'FM':
                exit('Federated States of Micronesia');
            'MD':
                exit('The Republic of Moldova');
            'MC':
                exit('Monaco');
            'MN':
                exit('Mongolia');
            'ME':
                exit('Montenegro');
            'MS':
                exit('Montserrat');
            'MA':
                exit('Morocco');
            'MZ':
                exit('Mozambique');
            'MM':
                exit('Myanmar');
            'NA':
                exit('Namibia');
            'NR':
                exit('Nauru');
            'NP':
                exit('Nepal');
            'NL':
                exit('Netherlands');
            'NC':
                exit('New Caledonia');
            'NZ':
                exit('New Zealand');
            'NI':
                exit('Nicaragua');
            'NE':
                exit('Niger');
            'NG':
                exit('Nigeria');
            'NU':
                exit('Niue');
            'NF':
                exit('Norfolk Island');
            'MP':
                exit('Northern Mariana Islands');
            'NO':
                exit('Norway');
            'OM':
                exit('Oman');
            'PK':
                exit('Pakistan');
            'PW':
                exit('Palau');
            'PS':
                exit('State of Palestine');
            'PA':
                exit('Panama');
            'PG':
                exit('Papua New Guinea');
            'PY':
                exit('Paraguay');
            'PE':
                exit('Peru');
            'PH':
                exit('Philippines');
            'PN':
                exit('Pitcairn');
            'PL':
                exit('Poland');
            'PT':
                exit('Portugal');
            'PR':
                exit('Puerto Rico');
            'QA':
                exit('Qatar');
            'MK':
                exit('Republic of North Macedonia');
            'RO':
                exit('Romania');
            'RU':
                exit('Russian Federation');
            'RW':
                exit('Rwanda');
            'RE':
                exit('Réunion');
            'BL':
                exit('Saint Barthélemy');
            'SH':
                exit('Saint Helena, Ascension and Tristan da Cunha');
            'KN':
                exit('Saint Kitts and Nevis');
            'LC':
                exit('Saint Lucia');
            'MF':
                exit('Saint Martin (French part)');
            'PM':
                exit('Saint Pierre and Miquelon');
            'VC':
                exit('Saint Vincent and the Grenadines');
            'WS':
                exit('Samoa');
            'SM':
                exit('San Marino');
            'ST':
                exit('Sao Tome and Principe');
            'SA':
                exit('Saudi Arabia');
            'SN':
                exit('Senegal');
            'RS':
                exit('Serbia');
            'SC':
                exit('Seychelles');
            'SL':
                exit('Sierra Leone');
            'SG':
                exit('Singapore');
            'SX':
                exit('Sint Maarten (Dutch part)');
            'SK':
                exit('Slovakia');
            'SI':
                exit('Slovenia');
            'SB':
                exit('Solomon Islands');
            'SO':
                exit('Somalia');
            'ZA':
                exit('South Africa');
            'GS':
                exit('South Georgia and the South Sandwich Islands');
            'SS':
                exit('South Sudan');
            'ES':
                exit('Spain');
            'LK':
                exit('Sri Lanka');
            'SD':
                exit('Sudan');
            'SR':
                exit('Suriname');
            'SJ':
                exit('Svalbard and Jan Mayen');
            'SE':
                exit('Sweden');
            'CH':
                exit('Switzerland');
            'SY':
                exit('Syrian Arab Republic');
            'TW':
                exit('Taiwan (Province of China)');
            'TJ':
                exit('Tajikistan');
            'TZ':
                exit('Tanzania, United Republic of');
            'TH':
                exit('Thailand');
            'TL':
                exit('Timor-Leste');
            'TG':
                exit('Togo');
            'TK':
                exit('Tokelau');
            'TO':
                exit('Tonga');
            'TT':
                exit('Trinidad and Tobago');
            'TN':
                exit('Tunisia');
            'TR':
                exit('Turkey');
            'TM':
                exit('Turkmenistan');
            'TC':
                exit('Turks and Caicos Islands');
            'TV':
                exit('Tuvalu');
            'UG':
                exit('Uganda');
            'UA':
                exit('Ukraine');
            'AE':
                exit('United Arab Emirates');
            'GB':
                exit('United Kingdom of Great Britain and Northern Ireland');
            'UM':
                exit('United States Minor Outlying Islands');
            'US':
                exit('United States of America');
            'UY':
                exit('Uruguay');
            'UZ':
                exit('Uzbekistan');
            'VU':
                exit('Vanuatu');
            'VE':
                exit('Bolivarian Republic of Venezuela');
            'VN':
                exit('Viet Nam');
            'VG':
                exit('Virgin Islands (British)');
            'VI':
                exit('Virgin Islands (U.S.)');
            'WF':
                exit('Wallis and Futuna');
            'EH':
                exit('Western Sahara');
            'YE':
                exit('Yemen');
            'ZM':
                exit('Zambia');
            'ZW':
                exit('Zimbabwe');
            'AX':
                exit('Åland Islands');

        end;
    end;
}
