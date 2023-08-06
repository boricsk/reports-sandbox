report 50033 "SEI Purchase order"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/Rep50033.PurchaseOrder.rdlc';
    ApplicationArea = All;
    Caption = 'SEI Purchase order', Locked = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(Comp_Name; Name) { }
            column(Comp_Address; Address) { }
            column(Comp_City; City) { }
            column(Comp_Post_Code; "Post Code") { }
            column(Comp_Phone_No_; "Phone No.") { }
            column(Comp_Fax_No_; "Fax No.") { }
            column(Comp_VAT_Registration_No_; "VAT Registration No.") { }
            column(Comp_HUNLOC_EU_VAT_Registration_No_; "HUNLOC EU VAT Registration No.") { }
            column(Comp_Bank_Name; "Bank Name") { }
            column(Comp_IBAN; IBAN) { }
            column(Comp_SWIFT_Code; "SWIFT Code") { }
            column(Comp_Giro_No_; "Giro No.") { }
        }
        dataitem("Purchase Header"; "Purchase Header")
        {
            column(PHPay_to_Name; "Pay-to Name") { }
            column(PHPay_to_Address; "Pay-to Address") { }
            column(PHPay_to_City; "Pay-to City") { }
            column(PHPay_to_Post_Code; "Pay-to Post Code") { }
            column(PHPay_to_Country_Region_Code; "Pay-to Country/Region Code") { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(PHVAT_Registration_No_; "VAT Registration No.") { }
            column(PHPosting_Date; "Posting Date") { }
            column(No_; "No.") { }
            column(PHPrepmt__Payment_Terms_Code; "Prepmt. Payment Terms Code") { }
            column(Document_Type; "Document Type") { }
            column(Prices_Including_VAT; "Prices Including VAT") { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(PLDocument_No_; "Document No.") { }
                column(Line_No_; "Line No.") { }
                //column(PL_Document_Type;"Document Type"){}
                column(PLItemNo_; "No.") { }
                column(PLDescription; Description) { }
                column(PLVendor_Item_No_; "Vendor Item No.") { }
                column(PLQuantity; Quantity) { }
                column(PLUnit_of_Measure_Code; "Unit of Measure Code") { }
                column(PLDirect_Unit_Cost; "Direct Unit Cost") { }
                column(PLVAT_Identifier; "VAT Identifier") { }
                column(PLPlanned_Receipt_Date; "Planned Receipt Date") { }
                column(PLAmount; Amount) { }
                column(RFQNumber; GetRFQNumber("Purchase Line"."No.")) { }
                column(CurrencyCode; GetCurrencyCode("Document Type", "Document No.")) { }
                column(Amount_Including_VAT; "Amount Including VAT") { }
                //column(GetMessage; GetMessage("Document No.", "Line No.", "Purchase Header"."Document Type")) { }
                dataitem("Purch. Comment Line"; "Purch. Comment Line")
                {
                    DataItemLink = "No." = field("Document No.");
                    column(CommentNo_; "No.") { }
                    column(Comment; Comment) { }

                    trigger OnPostDataItem()
                    begin
                        "Purch. Comment Line".SetFilter("Line No.", format("Purchase Line"."Line No."));
                    end;

                }

            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                //group(GroupName)
                // {
                //     field(Name; SourceExpression)
                //     {
                //         ApplicationArea = All;

                //     }
                //}
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    labels
    {
        LblTitle = 'Purchase order', Locked = true;
        LblSupplier = 'Supplier details', Locked = true;
        LblCustomer = 'Customer details', Locked = true;
        LblSupplierNo = 'Supplier no.', Locked = true;
        LblSupplierVATNo = 'Supplier VAT no.', Locked = true;
        LblPhone = 'Phone', Locked = true;
        LblFax = 'Fax', Locked = true;
        LblCustomerVATNo = 'Customer VAT no.', Locked = true;
        LblCustomerEUVATNo = 'Customer EU VAT no.', Locked = true;
        LblCustomerGiro = 'Giro no.', Locked = true;
        LblCustomerBank = 'Bank', Locked = true;
        LblCustomerIBAN = 'IBAN :', Locked = true;
        LblCustomerSWIFT = 'SWIFT code', Locked = true;
        LblPosting = 'Posting date', Locked = true;
        LblOrderNo = 'Order number', Locked = true;
        LblPriceInclVAT = 'Prices including VAT', Locked = true;
        LblItemNo = 'Item no.', Locked = true;
        LblDesc = 'Description', Locked = true;
        LblSuppItemNo = 'Supp. item no.', Locked = true;
        LblQty = 'Quantity', Locked = true;
        LblUnit = 'Unit', Locked = true;
        LblDirectUnitCost = 'Direct unit cost', Locked = true;
        LblVATID = 'VAT ID', Locked = true;
        LblReqDate = 'Req. date', Locked = true;
        LblAmount = 'Amount', Locked = true;
        LblFootNote1 = 'Payment terms :', Locked = true;
        LblFootNote2 = 'Please confirm the order within three working days.', Locked = true;
        LblFootNote3 = 'To comply with the purchasing rules please refer to Sumitomo Electric Industries Ltd. Terms and Conditions of Purchase.', Locked = true;
        LbLControlled = 'Controlled by', Locked = true;
        LblAuth = 'Authorized by', Locked = true;
        LblPage = 'Page :', Locked = true;
        LblCreated = 'Printed :', Locked = true;
        LblRFQ = 'RFQ number :', Locked = true;
        LblTotalQty = 'Total Quantity', Locked = true;
        LblTotal = 'Total', Locked = true;
        LblNotes = 'Notes', Locked = true;

    }

    var
        ItemRec: Record Item;
        PurchHeader: Record "Purchase Header";

    local procedure GetRFQNumber(Item: Code[20]): Text
    begin
        if ItemRec.Get(Item) then
            exit(ItemRec."Common Item No.")
    end;

    local procedure GetCurrencyCode(DocType: Enum "Purchase Document Type"; OrderNum: Code[20]): Text
    begin
        PurchHeader.Get(DocType, OrderNum);
        if PurchHeader."Currency Code" = '' then begin
            exit('EUR');
        end
        else begin
            exit(PurchHeader."Currency Code");
        end;
    end;

    // local procedure GetMessage(BCOrderNumber: Code[20]; LineNum: Integer; DocType: Enum "Purchase Comment Document Type"): Text
    // var
    //     Comments: Record "Purch. Comment Line";
    // begin
    //     Comments.Init();
    //     Comments.SetFilter("Document Type", format(DocType));
    //     Comments.SetFilter("No.", BCOrderNumber);
    //     Comments.SetFilter("Line No.", format(LineNum));
    //     exit(Comments.Comment);

    // end;
}