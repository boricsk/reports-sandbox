page 50037 "POC Card Page"
{
    UsageCategory = Administration;
    Caption = 'POC Card Page';
    PageType = Card;
    SourceTable = "SEI POC Master data";
    ApplicationArea = All;
    //Editable = false;

    layout
    {
        area(content)
        {
            group("Purchase order details")
            {
                field("PO Number"; Rec."PO Number") { ApplicationArea = All; TableRelation = "Purchase Header"."No."; }
                field("PO Line number"; Rec."PO Line number")
                {
                    ApplicationArea = All;
                    TableRelation = "Purchase Line"."Line No." where("Document No." = FIELD("PO Number"));
                    trigger OnValidate()
                    begin
                        PurchaseLine.Init();
                        PurchaseLine.SetFilter("Document No.", Rec."PO Number");
                        PurchaseLine.SetFilter("Line No.", Format(Rec."PO Line number"));
                        if PurchaseLine.Find('-') then begin
                            Rec."Item description" := PurchaseLine.Description;
                            Rec."Item number" := PurchaseLine."No.";
                            Rec.Quantity := PurchaseLine.Quantity;
                            Rec."Requesterd ETA" := PurchaseLine."Requested Receipt Date";
                            Rec."SO number" := PurchaseLine."SEI Sales Order No.";
                            Rec."Remaining qty" := PurchaseLine.Quantity;
                            Rec."Line amount" := PurchaseLine.Amount;
                            if PurchaseLine."Currency Code" = '' then begin
                                Rec."Currency code" := 'EUR';
                            end else begin
                                Rec."Currency code" := PurchaseLine."Currency Code";
                            end;
                            Rec."Unit of measure" := PurchaseLine."Unit of Measure";
                            Rec."Unit price" := PurchaseLine."Unit Cost";
                        end;

                        PurchaseHeader.Init();
                        if PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, rec."PO Number") then begin
                            Rec.Supplier := PurchaseHeader."Pay-to Vendor No.";
                            Rec."Supplier name" := PurchaseHeader."Pay-to Name";
                        end;

                        rec."Area" := getAreaCode(rec."Item number");
                        rec."Shipping unit" := getShippingUnit(rec."Item number");

                    end;
                }
                field("Date of order"; Rec."Date of order")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec."Requested LT" := (rec."Requesterd ETA" - rec."Date of order");
                    end;
                }
                field("Date of confirmation"; Rec."Date of confirmation") { ApplicationArea = All; }
                field("SO number"; Rec."SO number") { ApplicationArea = All; Editable = false; }
                field("Shipment on way"; Rec."Shipment on way") { ApplicationArea = All; Editable = false; }
                field("Completely arrived"; Rec."Completely arrived") { ApplicationArea = All; Editable = false; }
                field("Unit price"; Rec."Unit price") { ApplicationArea = All; Editable = false; }
                field("Line amount"; Rec."Line amount") { ApplicationArea = All; Editable = false; }
                field("Currency code"; Rec."Currency code") { ApplicationArea = All; Editable = false; }
            }
            group("Supplier information")
            {
                field(Supplier; Rec.Supplier) { ApplicationArea = All; Editable = false; }
                field("Supplier name"; Rec."Supplier name") { ApplicationArea = All; Editable = false; }

            }
            group("Area and material type")
            {
                field("Area"; Rec."Area") { ApplicationArea = All; Editable = false; }
                field("Shipping unit"; Rec."Shipping unit") { ApplicationArea = All; Editable = false; }
            }
            group("Item details")
            {
                field("Item number"; Rec."Item number") { ApplicationArea = All; Editable = false; }
                field("Item description"; Rec."Item description") { ApplicationArea = All; Editable = false; }
                field("Unit of measure"; Rec."Unit of measure") { ApplicationArea = All; Editable = false; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; Editable = false; }
                field("Remaining qty"; Rec."Remaining qty") { ApplicationArea = All; Editable = false; }
            }
            group("Shipment date informations")
            {
                field("Requesterd ETA"; Rec."Requesterd ETA") { ApplicationArea = All; Editable = false; }
                field("Confirmed ETD"; Rec."Confirmed ETD") { ApplicationArea = All; }
                field("Confirmed ETA"; Rec."Confirmed ETA") { ApplicationArea = All; }
                field("Confirmed ETA (Modified)"; Rec."Confirmed ETA (Modified)") { ApplicationArea = All; }
                field("Completely arrive date"; Rec."Completely arrive date") { ApplicationArea = All; Editable = false; }
            }
            group("Lead time informations")
            {
                field("Requested LT"; Rec."Requested LT") { ApplicationArea = All; Editable = false; }
                field("First shipment LT"; Rec."Fist shipment LT") { ApplicationArea = All; Editable = false; }
                field("Last shipment LT"; Rec."Last shipment LT") { ApplicationArea = All; Editable = false; }
                field("On time status"; Rec."On time status") { ApplicationArea = All; Editable = false; }
                field("Delay in days"; Rec."Delay in days") { ApplicationArea = All; Editable = false; }
            }
            group("Comments")
            {
                field(Comment; Rec.Comment) { ApplicationArea = All; }
                field("Comment 2"; Rec."Comment 2") { ApplicationArea = All; }
            }
            group("Arrival informations")
            {
                group("Part 1")
                {
                    field("Arrival date 1"; Rec."Arrival date 1")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            calcRemainingQty();
                            checkShipmentOnWay();
                            calcLastDate();
                        end;
                    }
                    field("Arrival qty 1"; Rec."Arrival qty 1")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            calcRemainingQty();
                            checkShipmentOnWay();
                        end;
                    }
                }
                group("Part 2")
                {
                    field("Arrival date 2"; Rec."Arrival date 2")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            calcRemainingQty();
                            checkShipmentOnWay();
                            calcLastDate();
                        end;
                    }
                    field("Arrival qty 2"; Rec."Arrival qty 2")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            calcRemainingQty();
                            checkShipmentOnWay();
                        end;
                    }
                }
                group("Part 3")
                {
                    field("Arrival date 3"; Rec."Arrival date 3")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            calcRemainingQty();
                            checkShipmentOnWay();
                            calcLastDate();
                        end;
                    }
                    field("Arrival qty 3"; Rec."Arrival qty 3")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            calcRemainingQty();
                            checkShipmentOnWay();
                        end;
                    }
                }
                group("Part 4")
                {
                    field("Arrival date 4"; Rec."Arrival date 4")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            calcRemainingQty();
                            checkShipmentOnWay();
                            calcLastDate();
                        end;
                    }
                    field("Arrival qty 4"; Rec."Arrival qty 4")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            calcRemainingQty();
                            checkShipmentOnWay();
                        end;
                    }
                }
                group("Part 5")
                {
                    field("Arrival date 5"; Rec."Arrival date 5")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            calcRemainingQty();
                            checkShipmentOnWay();
                            calcLastDate();
                        end;
                    }
                    field("Arrival qty 5"; Rec."Arrival qty 5")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            calcRemainingQty();
                            checkShipmentOnWay();
                        end;
                    }
                }
                group("Part 6")
                {
                    field("Arrival date 6"; Rec."Arrival date 6")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            calcRemainingQty();
                            checkShipmentOnWay();
                            calcLastDate();
                        end;
                    }
                    field("Arrival qty 6"; Rec."Arrival qty 6")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            calcRemainingQty();
                            checkShipmentOnWay();
                        end;
                    }
                }
                group("Part 7")
                {
                    field("Arrival date 7"; Rec."Arrival date 7")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            calcRemainingQty();
                            checkShipmentOnWay();
                            calcLastDate();
                        end;
                    }
                    field("Arrival qty 7"; Rec."Arrival qty 7")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            calcRemainingQty();
                            checkShipmentOnWay();
                        end;
                    }
                }
            }

        }
    }
    actions
    {
        area(Navigation)
        {
            // group(Test)
            // {
            //     action(TestBtn)
            //     {
            //         ApplicationArea = All;
            //         trigger OnAction()
            //         begin

            //         end;
            //     }
            // }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin

    end;


    trigger OnModifyRecord(): Boolean
    begin
        //ha del-el kitörli és nem ad meg új értéket akkor nem fut a field onValidat-ja. Ezzel viszont aktualizálom a változtatásokat A LT-ben és a On time statusban
        //ez csak akkor fut ha lelép a sorról.
        calcRemainingQty();
        checkShipmentOnWay();
        calcLastDate();
        Rec."Requested LT" := (rec."Requesterd ETA" - rec."Date of order");
        if (rec."Completely arrived") and (rec."On time status" = rec."On time status"::Delay) then
            rec."Delay in days" := Rec."Last shipment LT" - rec."Requested LT"
        else
            rec."Delay in days" := 0;
    end;

    trigger OnInit()
    begin
        manufacturingSetup.Init();
        manufacturingSetup.Get();
        coilLT := manufacturingSetup."Coil target LT";
        cutLT := manufacturingSetup."Cut target LT";
        finishLT := manufacturingSetup."Finished target LT";
    end;

    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        User: Record User;
        DocumentNum: Code[20];
        //lblIssueDateError: Label 'Given date is in the past or in the future!';
        lblUpdateComplete: Label 'Data update has been completed!';
        manufacturingSetup: Record "Manufacturing Setup";
        coilLT, cutLT, finishLT : Integer;
        dimension: Record "Default Dimension";
        items: Record Item;
        POCMainPage: Page "SEI POC";

    local procedure getAreaCode(item: Code[20]): Code[20]
    begin
        dimension.Init();
        if dimension.Get(27, item, 'DIVISION') then
            exit(dimension."Dimension Value Code");
    end;

    local procedure getShippingUnit(item: Code[20]): Text
    begin
        items.Init();
        if items.Get(item) then begin
            if items."Purchasing Code" = 'COIL' then begin
                exit('Coil');
            end else begin
                if items."Purchasing Code" = 'CUT' then begin
                    exit('Cut');
                end else begin
                    if items."Purchasing Code" = 'FG' then begin
                        exit('Finish');
                    end else begin
                        if items."Purchasing Code" = 'SHIELDED' then begin
                            exit('Shielded');
                        end else begin
                            exit('Spec');
                        end;
                    end;
                end;
            end;
        end;
    end;

    local procedure updateRequestedDate()
    var
        purchaseOrderLine: Record "Purchase Line";
        POCData: Record "SEI POC Master data";
        year, month, day : Integer;
    begin
        purchaseOrderLine.Reset();
        POCData.Reset();
        if purchaseOrderLine.Find('-') then begin
            repeat
                if POCData.Get(purchaseOrderLine."Document No.", purchaseOrderLine."Line No.") then begin
                    if POCData."Requesterd ETA" <> purchaseOrderLine."Requested Receipt Date" then begin
                        POCData."Requesterd ETA" := purchaseOrderLine."Requested Receipt Date";
                        POCData."Requested LT" := POCData."Requesterd ETA" - POCData."Date of order";

                        //On time statusz beállítás, teljes beérkezést nézi csak
                        if (POCData."Completely arrived") then begin
                            //Ha spec a shipping unit akkor a kért LT figyeli a delay beállításhoz
                            if POCData."Shipping unit" = 'Spec' then begin
                                if (POCData."Last shipment LT" > POCData."Requested LT") then begin
                                    POCData."On time status" := POCData."On time status"::Delay;
                                end else begin
                                    POCData."On time status" := POCData."On time status"::"On time";
                                end;
                                //Delay calculation
                                if (POCData."On time status" = POCData."On time status"::Delay) then
                                    POCData."Delay in days" := POCData."Last shipment LT" - POCData."Requested LT"
                                else
                                    POCData."Delay in days" := 0;

                                //Business year update
                                year := Date2DMY(POCData."Requesterd ETA", 3);
                                month := Date2DMY(POCData."Requesterd ETA", 2);
                                day := Date2DMY(POCData."Requesterd ETA", 1);
                                if (month > 3) then begin
                                    POCData."Business year" := year;
                                end else begin
                                    POCData."Business year" := year - 1;
                                end;
                                if (month >= 4) and (month <= 12) then begin
                                    POCData.Month := month - 3;
                                end else begin
                                    POCData.Month := month + 9;
                                end;

                            end else begin
                                // ha a shipping unit nem spec akkor a manuf setupban beállított értékekkel dolgozik kábeltipusunként
                                if POCData."Shipping unit" = 'Coil' then begin
                                    if POCData."Last shipment LT" > coilLT then begin
                                        POCData."On time status" := POCData."On time status"::Delay;
                                    end else begin
                                        POCData."On time status" := POCData."On time status"::"On time";
                                    end;
                                end;

                                if (POCData."Shipping unit" = 'Cut') or (POCData."Shipping unit" = 'Shielded') then begin
                                    if POCData."Last shipment LT" > cutLT then begin
                                        POCData."On time status" := POCData."On time status"::Delay;
                                    end else begin
                                        POCData."On time status" := POCData."On time status"::"On time";
                                    end;
                                end;

                                if POCData."Shipping unit" = 'Finish' then begin
                                    if POCData."Last shipment LT" > finishLT then begin
                                        POCData."On time status" := POCData."On time status"::Delay;
                                    end else begin
                                        POCData."On time status" := POCData."On time status"::"On time";
                                    end;
                                end;
                                //Delay calculation
                                if (POCData."On time status" = POCData."On time status"::Delay) then
                                    POCData."Delay in days" := POCData."Last shipment LT" - POCData."Requested LT"
                                else
                                    POCData."Delay in days" := 0;

                                //Business year update
                                year := Date2DMY(POCData."Requesterd ETA", 3);
                                month := Date2DMY(POCData."Requesterd ETA", 2);
                                day := Date2DMY(POCData."Requesterd ETA", 1);
                                if (month > 3) then begin
                                    POCData."Business year" := year;
                                end else begin
                                    POCData."Business year" := year - 1;
                                end;
                                if (month >= 4) and (month <= 12) then begin
                                    POCData.Month := month - 3;
                                end else begin
                                    POCData.Month := month + 9;
                                end;
                            end;
                        end else begin
                            POCData."On time status" := POCData."On time status"::"Not complete";
                        end;

                        POCData.Modify();
                    end;
                end;
            until purchaseOrderLine.Next() = 0;
            Message(lblUpdateComplete);
        end;
        //Message('Nothing to update!');
    end;

    local procedure checkShipmentOnWay()
    begin
        if (rec."Arrival qty 1" <> 0) and (rec."Arrival date 1" = 0D) or
        (rec."Arrival qty 2" <> 0) and (rec."Arrival date 2" = 0D) or
        (rec."Arrival qty 3" <> 0) and (rec."Arrival date 3" = 0D) or
        (rec."Arrival qty 4" <> 0) and (rec."Arrival date 4" = 0D) or
        (rec."Arrival qty 5" <> 0) and (rec."Arrival date 5" = 0D) or
        (rec."Arrival qty 6" <> 0) and (rec."Arrival date 6" = 0D) or
        (rec."Arrival qty 7" <> 0) and (rec."Arrival date 7" = 0D)
        then
            rec."Shipment on way" := true
        else
            rec."Shipment on way" := false;
    end;

    local procedure calcRemainingQty()
    begin
        rec."Remaining qty" := rec.Quantity - (rec."Arrival qty 1" + rec."Arrival qty 2" + rec."Arrival qty 3" + rec."Arrival qty 4" + rec."Arrival qty 5" + rec."Arrival qty 6" + rec."Arrival qty 7");

        // Teljes beérkezés beállítása, a részmennyiség egyenlő-e az original qty-vel és van-e beérkezési dátum
        if (rec."Arrival qty 1" = rec.Quantity) and (rec."Arrival date 1" <> 0D) then begin
            rec."Completely arrived" := true;
        end else begin
            if (rec."Arrival qty 1" + rec."Arrival qty 2" = rec.Quantity) and (rec."Arrival date 1" <> 0D) and (rec."Arrival date 2" <> 0D) then begin
                rec."Completely arrived" := true;
            end else begin
                if (rec."Arrival qty 1" + rec."Arrival qty 2" + rec."Arrival qty 3" = rec.Quantity) and (rec."Arrival date 1" <> 0D) and (rec."Arrival date 2" <> 0D) and (rec."Arrival date 3" <> 0D) then begin
                    rec."Completely arrived" := true;
                end else begin
                    if (rec."Arrival qty 1" + rec."Arrival qty 2" + rec."Arrival qty 3" + rec."Arrival qty 4" = rec.Quantity) and (rec."Arrival date 1" <> 0D) and (rec."Arrival date 2" <> 0D) and (rec."Arrival date 3" <> 0D) and (rec."Arrival date 4" <> 0D) then begin
                        rec."Completely arrived" := true;
                    end else begin
                        if (rec."Arrival qty 1" + rec."Arrival qty 2" + rec."Arrival qty 3" + rec."Arrival qty 4" + rec."Arrival qty 5" = rec.Quantity) and (rec."Arrival date 1" <> 0D) and (rec."Arrival date 2" <> 0D) and (rec."Arrival date 3" <> 0D) and (rec."Arrival date 4" <> 0D) and (rec."Arrival date 5" <> 0D) then begin
                            rec."Completely arrived" := true;
                        end else begin
                            if (rec."Arrival qty 1" + rec."Arrival qty 2" + rec."Arrival qty 3" + rec."Arrival qty 4" + rec."Arrival qty 5" + rec."Arrival qty 6" = rec.Quantity) and (rec."Arrival date 1" <> 0D) and (rec."Arrival date 2" <> 0D) and (rec."Arrival date 3" <> 0D) and (rec."Arrival date 4" <> 0D) and (rec."Arrival date 5" <> 0D) and (rec."Arrival date 6" <> 0D) then begin
                                rec."Completely arrived" := true;
                            end else begin
                                if (rec."Arrival qty 1" + rec."Arrival qty 2" + rec."Arrival qty 3" + rec."Arrival qty 4" + rec."Arrival qty 5" + rec."Arrival qty 6" + rec."Arrival qty 7" = rec.Quantity) and (rec."Arrival date 1" <> 0D) and (rec."Arrival date 2" <> 0D) and (rec."Arrival date 3" <> 0D) and (rec."Arrival date 4" <> 0D) and (rec."Arrival date 5" <> 0D) and (rec."Arrival date 6" <> 0D) and (rec."Arrival date 7" <> 0D) then begin
                                    rec."Completely arrived" := true;
                                end else begin
                                    rec."Completely arrived" := false;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local procedure calcLastDate()
    var
        arrivalDate: array[7] of Date;
        maxDate: Date;
        i, year, month, day : Integer;
    begin
        arrivalDate[1] := rec."Arrival date 1";
        arrivalDate[2] := rec."Arrival date 2";
        arrivalDate[3] := rec."Arrival date 3";
        arrivalDate[4] := rec."Arrival date 4";
        arrivalDate[5] := rec."Arrival date 5";
        arrivalDate[6] := rec."Arrival date 6";
        arrivalDate[7] := rec."Arrival date 7";

        maxDate := 0D;
        for i := 1 to 7 do begin
            if arrivalDate[i] > maxDate then begin
                maxDate := arrivalDate[i]
            end;
        end;
        //A teljesen beérkezett dátum csak akkor kap értéket, ha a teljes szállítmány bejött
        if rec."Completely arrived" then
            rec."Completely arrive date" := maxDate
        else
            rec."Completely arrive date" := 0D;

        //Ha a teljesen beérkezett 0D akkor kibára megy a kivonás, ha nincs ellenőrizve
        if (rec."Completely arrive date" <> 0D) and rec."Completely arrived" then
            rec."Last shipment LT" := Rec."Completely arrive date" - rec."Date of order";

        //Az első szállítás LT-je
        if rec."Arrival date 1" <> 0D then
            rec."Fist shipment LT" := Rec."Arrival date 1" - rec."Date of order";

        //On time statusz beállítás, teljes beérkezést nézi csak
        if (rec."Completely arrived") then begin
            //Ha spec a shipping unit akkor a kért LT figyeli a delay beállításhoz
            if rec."Shipping unit" = 'Spec' then begin
                if (rec."Last shipment LT" > rec."Requested LT") then begin
                    rec."On time status" := rec."On time status"::Delay;
                end else begin
                    rec."On time status" := rec."On time status"::"On time";
                end;
            end else begin
                // ha a shipping unit nem spec akkor a manuf setupban beállított értékekkel dolgozik kábeltipusunként
                if rec."Shipping unit" = 'Coil' then begin
                    if rec."Last shipment LT" > coilLT then begin
                        rec."On time status" := rec."On time status"::Delay;
                    end else begin
                        rec."On time status" := rec."On time status"::"On time";
                    end;
                end;

                if (rec."Shipping unit" = 'Cut') or (rec."Shipping unit" = 'Shielded') then begin
                    if rec."Last shipment LT" > cutLT then begin
                        rec."On time status" := rec."On time status"::Delay;
                    end else begin
                        rec."On time status" := rec."On time status"::"On time";
                    end;
                end;

                if rec."Shipping unit" = 'Finish' then begin
                    if rec."Last shipment LT" > finishLT then begin
                        rec."On time status" := rec."On time status"::Delay;
                    end else begin
                        rec."On time status" := rec."On time status"::"On time";
                    end;
                end;
            end;
        end else begin
            rec."On time status" := rec."On time status"::"Not complete";
        end;

        //Delay calculation
        if (rec."Completely arrived") and (rec."On time status" = rec."On time status"::Delay) then
            rec."Delay in days" := Rec."Last shipment LT" - rec."Requested LT"
        else
            rec."Delay in days" := 0;

        //Üzleti év meghatározás
        if rec."Completely arrived" then begin
            year := Date2DMY(rec."Requesterd ETA", 3);
            month := Date2DMY(rec."Requesterd ETA", 2);
            day := Date2DMY(rec."Requesterd ETA", 1);
            if (month > 3) then begin
                rec."Business year" := year;
                //rec.Month := month;
            end else begin
                rec."Business year" := year - 1;
                //rec.Month := month;
            end;

            if (month >= 4) and (month <= 12) then begin
                rec.Month := month - 3;
            end else begin
                rec.Month := month + 9;
            end;
        end;

        if rec."Completely arrived" then begin
            if rec."On time status" = rec."On time status"::Delay then begin
                rec."Delayed quantity" := rec.Quantity;
                rec."On time quantity" := 0;
            end;
            if rec."On time status" = rec."On time status"::"On time" then begin
                rec."Delayed quantity" := 0;
                rec."On time quantity" := rec.Quantity;
            end;
            if rec."On time status" = rec."On time status"::"Not complete" then begin
                rec."Delayed quantity" := 0;
                rec."On time quantity" := 0;
            end;

            if rec."Shipping unit" = 'Coil' then begin
                rec."Coil LT" := rec."Last shipment LT";
                rec."Cut LT" := 0;
                rec."Finish LT" := 0;
                rec."Spec LT" := 0;
            end;

            if (rec."Shipping unit" = 'Cut') or (rec."Shipping unit" = 'Shielded') then begin
                rec."Coil LT" := 0;
                rec."Cut LT" := rec."Last shipment LT";
                rec."Finish LT" := 0;
                rec."Spec LT" := 0;
            end;
            if rec."Shipping unit" = 'Finish' then begin
                rec."Coil LT" := 0;
                rec."Cut LT" := 0;
                rec."Finish LT" := rec."Last shipment LT";
                rec."Spec LT" := 0;
            end;
            if rec."Shipping unit" = 'Spec' then begin
                rec."Coil LT" := 0;
                rec."Cut LT" := 0;
                rec."Finish LT" := 0;
                rec."Spec LT" := rec."Last shipment LT";
            end;

        end else begin
            rec."Delayed quantity" := 0;
            rec."On time quantity" := 0;

        end;
    end;
}
