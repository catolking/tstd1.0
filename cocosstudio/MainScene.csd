<GameFile>
  <PropertyGroup Name="MainScene" Type="Scene" ID="a2ee0952-26b5-49ae-8bf9-4f1d6279b798" Version="2.3.3.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Scene" ctype="GameNodeObjectData">
        <Size X="960.0000" Y="540.0000" />
        <Children>
          <AbstractNodeData Name="btnFighting" ActionTag="-1887389022" Tag="528" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="4.0080" RightMargin="805.9920" TopMargin="2.9400" BottomMargin="477.0600" TouchEnable="True" FontSize="48" ButtonText="战斗" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="16" Scale9Height="14" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" ctype="ButtonObjectData">
            <Size X="150.0000" Y="60.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="79.0080" Y="507.0600" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.0823" Y="0.9390" />
            <PreSize X="0.1563" Y="0.1111" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
            <PressedFileData Type="Default" Path="Default/Button_Press.png" Plist="" />
            <NormalFileData Type="Default" Path="Default/Button_Normal.png" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="ctrlLayer" ActionTag="-1973356984" Tag="16" IconVisible="True" LeftMargin="920.0000" RightMargin="40.0000" TopMargin="500.0000" BottomMargin="40.0000" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="btnPlus" ActionTag="-1718710023" Tag="15" RotationSkewX="45.0000" RotationSkewY="45.0000" IconVisible="False" HorizontalEdge="RightEdge" VerticalEdge="BottomEdge" LeftMargin="-31.9996" RightMargin="-32.0004" TopMargin="-32.0000" BottomMargin="-32.0000" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="34" Scale9Height="42" OutlineSize="0" ShadowOffsetX="0.0000" ShadowOffsetY="0.0000" Rotation="45.0000" ctype="ButtonObjectData">
                <Size X="64.0000" Y="64.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="0.0004" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0667" Y="0.1185" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Normal" Path="images/button/plus.png" Plist="" />
                <PressedFileData Type="Normal" Path="images/button/plus.png" Plist="" />
                <NormalFileData Type="Normal" Path="images/button/plus.png" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="920.0000" Y="40.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.9583" Y="0.0741" />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="nodeChat" ActionTag="1888750220" Tag="9" IconVisible="True" RightMargin="960.0000" TopMargin="540.0000" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="Image_1" ActionTag="-262122760" Alpha="51" Tag="6" IconVisible="False" LeftMargin="6.3549" RightMargin="-426.3549" TopMargin="-205.0000" BottomMargin="5.0000" Scale9Enable="True" LeftEage="42" RightEage="42" TopEage="26" BottomEage="26" Scale9OriginX="42" Scale9OriginY="26" Scale9Width="45" Scale9Height="27" ctype="ImageViewObjectData">
                <Size X="420.0000" Y="200.0000" />
                <AnchorPoint />
                <Position X="6.3549" Y="5.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.4375" Y="0.3704" />
                <FileData Type="Normal" Path="images/bg/chat.png" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="svChat" ActionTag="-909426631" Tag="8" IconVisible="False" LeftMargin="16.4427" RightMargin="-416.4427" TopMargin="-193.6495" BottomMargin="13.6495" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ComboBoxIndex="1" ColorAngle="90.0000" ScrollDirectionType="Vertical" ctype="ScrollViewObjectData">
                <Size X="400.0000" Y="180.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="216.4427" Y="103.6495" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.4167" Y="0.3333" />
                <SingleColor A="255" R="255" G="150" B="100" />
                <FirstColor A="255" R="255" G="150" B="100" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
                <InnerNodeSize Width="400" Height="300" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>