report 50032 "SEI Shipment status"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/Rep50032.ShipmentStatus.rdlc';
    ApplicationArea = All;
    Caption = 'SEI Shipment Status';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Warehouse Shipment Header"; "Warehouse Shipment Header")
        {
            RequestFilterFields = "Posting Date";
            column(HeaderNo_; "No.") { }
            column(HeaderPosting_Date; "Posting Date") { }

            dataitem("Warehouse Shipment Line"; "Warehouse Shipment Line")
            {
                DataItemLink = "No." = field("No.");
                RequestFilterFields = "Destination No.";
                column(No_; "No.") { }
                column(Source_No_; "Source No.") { }
                column(Item_No_; "Item No.") { }
                column(Destination_No_; "Destination No.") { }
                column(Quantity; Quantity) { }
                column(Qty__to_Ship; "Qty. to Ship") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(GetCustomerName; GetCustomerName("Destination No.")) { }
                column(FinishedStock; GetFinishedStock("Item No.")) { }
                //column(GetRMNumber; GetRMNumber(GetBOMNumber("Item No."))) { }
                column(WipStockLevel; GetFinishedStock(GetRMNumber(GetBOMNumber("Item No.")))) { }
                //column(GetPostingDate; GetPostingDate("No.")) { }

            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                // group(GroupName)
                // {
                //     field(GetPostingDate; GetPostingDate("Warehouse Shipment Line"."No."))
                //     {
                //         ApplicationArea = All;

                //     }
                // }
            }
        }


    }
    labels
    {
        LblTitle = 'Shipment status';
        LblDeliveryNote = 'Delivery note no.';
        LblOrderNo = 'Order no.';
        LblItemNo = 'Item no.';
        LblCustName = 'Customer name';
        LblQty = 'Qty.';
        LblQtyToShip = 'Qty. to ship';
        LblInventory = 'FG Inv.';
        Lbl0LInventory = '0L Inv.';
        LblUMC = 'Unit';
        LblBox = 'Box';
        LblWeight = 'Weight';

    }
    var
        CustomerRec: Record Customer;
        BOMLineRec: Record "Production BOM Line";
        BOMHeadRec: Record "Production BOM Header";
        ItemRec: Record Item;
        UsableForMRPInvetory: Decimal;


    local procedure GetCustomerName(CustomerCode: Code[20]): Text
    begin
        CustomerRec.Get(CustomerCode);
        exit(CustomerRec.Name)
    end;

    local procedure GetFinishedStock(Item: Code[20]): Decimal
    var
        ItemlLedgerEntryRec: Record "Item Ledger Entry";
        LocationRec: Record Location;
    begin
        if (Item <> '') or (Item <> 'None') then begin
            LocationRec.Reset();
            LocationRec.SetRange("SEI Usable for MRP", true);
            Clear(UsableForMRPInvetory);
            ItemlLedgerEntryRec.Reset();
            ItemlLedgerEntryRec.SetRange("Item No.", Item);
            ItemlLedgerEntryRec.CalcSums(Quantity);
            UsableForMRPInvetory := ItemlLedgerEntryRec.Quantity;
            exit(UsableForMRPInvetory);
        end else begin
            exit(0);
        end;

    end;

    local procedure GetBOMNumber(Item: Code[20]): Text
    begin
        if ItemRec.Get(Item) then
            if ItemRec."Production BOM No." <> '' then
                exit(ItemRec."Production BOM No.")
            else
                exit('')
    end;

    local procedure GetRMNumber(Finished: Code[20]): Text
    begin
        if BOMHeadRec.Get(Finished) then begin
            if BOMHeadRec.Status = BOMHeadRec.Status::Certified then begin
                BOMLineRec.SetFilter("Production BOM No.", Finished);

                if Finished <> '' then begin
                    if BOMLineRec.Find('-') then begin
                        repeat
                            if StrPos(BOMLineRec."No.", '0L-') <> 0 then
                                exit(BOMLineRec."No.")
                            else
                                exit('None')
                        until (BOMLineRec.Next = 0);

                    end;
                end;
            end;
        end else begin
            exit('None');
        end;
    end;

    // local procedure GetPostingDate(DocNo: Code[20]): Date
    // var
    //     WhseShipmentHeader: Record "Warehouse Shipment Header";
    // begin
    //     WhseShipmentHeader.Get(DocNo);
    //     exit(WhseShipmentHeader."Posting Date");
    // end;
}