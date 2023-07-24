' ********** Copyright 2019 Roku Corp.  All Rights Reserved. **********

function ShowDetailsView(content as Object, index as Integer, isContentList = true as Boolean) as Object
    m.details = CreateObject("roSGNode", "DetailsView")
    m.details.ObserveField("content", "OnDetailsContentSet")
    m.details.ObserveField("buttonSelected", "OnButtonSelected")
    m.details.isContentList = isContentList

    m.details.SetFields({
        content: content
    })

    ' must do this after setting content
    m.details.jumpToItem = index

    ' this will trigger job to show this View
    m.top.ComponentController.CallFunc("show", {
        view: m.details
    })

    return m.details
end function

sub OnDetailsContentSet(event as Object)
    btnsContent = CreateObject("roSGNode", "ContentNode")
    if event.GetData().TITLE = "Series"
        btnsContent.Update({ children: [{ title: "Episodes", id: "episodes" }] })
    else if event.GetData().TITLE = "Live Channels"
        btnsContent.Update({ children: [{ title: "Watch Live", id: "watch" }] })
    else
        btnsContent.Update({ children: [{ title: "Play", id: "play" }] })
    end if

    details = event.GetRoSGNode()
    details.buttons = btnsContent
end sub

sub OnButtonSelected(event as Object)
    details = event.GetRoSGNode()
    selectedButton = details.buttons.GetChild(event.GetData())

    if selectedButton.id = "play"
        videoView = OpenVideoPlayer(details.content, details.itemFocused, details.isContentList)
        videoView.ObserveField("wasClosed", "OnVideoWasClosed")
    else if selectedButton.id = "episodes"
        ShowEpisodePickerView(details.currentItem.seasons)
    end if
end sub

sub OnVideoWasClosed (event)
    videoView = event.GetRoSGNode()
    m.details.jumpToItem = videoView.currentIndex
end sub
