report 50092 "SEI On Time Delivery"
{
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/Rep50092.OnTimeDelivery.rdlc';
    ApplicationArea = All;
    Caption = 'SEI On Time Delivery';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Shipment Line"; "Sales Shipment Line")
        {
            column(Document_No_; "Document No.") { }
            column("Item"; "No.") { }
            column(Description; Description) { }
            column(Quantity; Quantity) { }
            column(Shortcut_Dimension_1_Code; "Shortcut Dimension 1 Code") { }
            column(Shipment_Date; "Shipment Date") { }
            column(Planned_Shipment_Date; "Planned Shipment Date") { }
            column(SEI_Changed_Order_Date; "SEI Changed Order Date") { }
            column(SEI_SAP_Original_Req__Date; "SEI SAP Original Req. Date") { }
            column("Requested_date"; GetRequestedDate("SEI SAP Original Req. Date", "SEI Changed Order Date")) { }
            column(calcDelayBasedConfirmation; calcDelayBasedConfirmation("Shipment Date", "Planned Shipment Date")) { }
            column(calcDelayBasedRequest; calcDelayBasedRequest("Shipment Date", GetRequestedDate("SEI SAP Original Req. Date", "SEI Changed Order Date"))) { }
            column(startDate; startDate) { }
            column(endDate; endDate) { }
            column(Location; Location) { }
            column(getCustomerName; getCustomerName("Document No.")) { }
            column(calcDelayedShipmentConfirmation; calcDelayedShipmentConfirmation("Shipment Date", "Planned Shipment Date")) { }
            column(calcDelayedShipmentRequest; calcDelayedShipmentRequest("Shipment Date", GetRequestedDate("SEI SAP Original Req. Date", "SEI Changed Order Date"))) { }
            column(itemsVisible; itemsVisible) { }
            column(isConformation; isConformation) { }
            column(isRequested; isRequested) { }

            trigger OnPreDataItem()
            begin
                "Sales Shipment Line".SetFilter(Quantity, '>0');
                "Sales Shipment Line".SetRange("Shipment Date", startDate, endDate);
                "Sales Shipment Line".SetRange("Shortcut Dimension 1 Code", Location);
            end;
        }

    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group("Period setup")
                {
                    field(startDate; startDate)
                    {
                        Caption = 'Sarting date';
                        ApplicationArea = All;

                    }
                    field(endDate; endDate)
                    {
                        Caption = 'Ending date';
                        ApplicationArea = All;
                    }
                    field(Location; Location)
                    {
                        TableRelation = "Dimension Value".Code where("Dimension Code" = const('DIVISION'));
                        Caption = 'Location code';
                        ApplicationArea = All;
                    }
                }
                group("View setup")
                {
                    field(itemsVisible; itemsVisible)
                    {
                        ApplicationArea = All;
                        Caption = 'Show items details';
                    }
                    field(isConformation; isConformation)
                    {
                        ApplicationArea = All;
                        Caption = 'Based on confirmation date';
                    }

                    field(isRequested; isRequested)
                    {
                        ApplicationArea = All;
                        Caption = 'Based on requested date';
                    }

                }
            }
        }

    }

    labels
    {
        LblTitle = 'On Time Delivery Report', Locked = true;
        LblOrderNo = 'Order no.';
        LblItemNo = 'Item no.';
        lblCustomer = 'Customer name';
        lblDelayBasedConfirmation = '* Delay based on confirmation [days]';
        lblDelayBasedRequest = '* Delay based on request date [days]';
        LblShipmentNum = 'Number of shipments';
        LblShipmentsOnTime = 'Number of on time shipment';
        LblShipmentsDelay = 'Number of delayed shipments';
        LblOTD = 'OTD ratio';
        lblFootNote = '* Negative numbers are represent the advance delivery, positive ones represent the delays. / A negatív számok az előre szállítást, a pozitívak a késéseket jelzik.', Locked = true;
        LblItem = 'Item';
        LblDesc = 'Description';
        lblBasedOnConfirmation = 'OTD report based on confirmation date';
        lblBasedOnRequested = 'OTD report based on requested date';

    }

    trigger OnInitReport()
    begin
        isConformation := true;
    end;

    var
        startDate, endDate : Date;
        Location: Code[20];
        SalesShipemtHeader: Record "Sales Shipment Header";
        itemsVisible, isConformation, isRequested : Boolean;


    local procedure getCustomerName(No: code[20]): Text
    begin
        if SalesShipemtHeader.Get(No) then
            exit(SalesShipemtHeader."Sell-to Customer Name")
    end;

    local procedure GetRequestedDate(OriginalDate: Date; ChangedDate: Date): Date
    begin
        if ChangedDate = 0D then
            exit(OriginalDate)
        else
            exit(ChangedDate)

    end;

    local procedure calcDelayBasedConfirmation(shipmentDate: Date; confirmDate: Date): Decimal
    begin
        if confirmDate <> 0D then
            exit(shipmentDate - confirmDate)
    end;

    local procedure calcDelayBasedRequest(shipmentDate: Date; RequestedDate: Date): Decimal
    begin
        if RequestedDate <> 0D then
            exit(shipmentDate - RequestedDate)
    end;

    local procedure calcDelayedShipmentConfirmation(shipmentDate: Date; confirmDate: Date): Integer
    begin
        if (shipmentDate - confirmDate) > 0 then
            exit(1)
        else
            exit(0)
    end;

    local procedure calcDelayedShipmentRequest(shipmentDate: Date; requestDate: Date): Integer
    begin
        if requestDate <> 0D then begin
            if (shipmentDate - requestDate) > 0 then
                exit(1)
            else
                exit(0)
        end else begin
            exit(0)
        end;
    end;

}