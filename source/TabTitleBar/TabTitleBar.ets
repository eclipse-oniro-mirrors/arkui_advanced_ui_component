/*
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { KeyCode } from '@ohos.multimodalInput.keyCode'

export declare type TabTitleBarMenuItem = {
  value: ResourceStr
  isEnabled: boolean
  action?: () => void
}

export declare type TabTitleBarTabItem = {
  title: ResourceStr
  icon?: ResourceStr
}

const PUBLIC_MORE = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMAAAADACAYAAABS3GwHAAAAIGNIUk0AAHomAACAhAAA+' +
  'gAAAIDoAAB1MAAA6mAAADqYAAAXcJy6UTwAAAAEZ0FNQQAAsY58+1GTAAAAAXNSR0IArs4c6QAAAAZiS0dEAP8A/wD/oL2nkwAAAAlwSFlzAAAO' +
  'xAAADsQBlSsOGwAABEZJREFUeNrt3D1rFFEUBuAxhmAhFlYpUohYiYWFRcAmKAhWK2pjo1iKf8BCMIKFf8BarCyMhVj4VZhGSKEg2FqJyCKWIhY' +
  'WnstMINgYsh+cmfs88BICydxw7jmzu2HvNg0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADBN+3r6dx+LXIqsRpa7FF8j48hm5Fn3Peo9mAEYRd' +
  'YjJ3f582Vj7nZfUe/eDsCRyMPI2h5/fyNyI/JDT6v3Tvt7sBllE15ETkxwjeORi5G3ke/6W737MgBnI68jh6ZwrcORq5HnhkC9+zAA5YXXy8jBK' +
  'V5zKXIu8jjyS7+rd+YBeNVtyrSVO9PRyBM9r94LSTfjWuTUDK9/eYIXeENUbb0zDsBi5PYc1rmj79U74wCszuih+F/ljrSi/+uud8YBGA10rayq' +
  'rnfGAVgb6FpZVV3vjAOwPNC1sqq63hkHYGWga2VVdb0XKt/8Rf1fd70zDsB4jmt5u3Tl9a59AMb6v+56ZxyArYGulVXV9c44ABtzXOup/q+73hk' +
  'H4N2cHio/Rj7r/7rrnXEAfkfuz2Gddb2v3ln/DfpgxneLzaY9xE3l9c46AH8iVyI/Z3Dt8nB/Xc+rd5H5QMy3yJemPVs6zY0edc9HUe/0Z4I/dQ' +
  '/N5Vjd0oTXKp9QcKFpD2qj3r0YgO1NeRM507TH6/bifeR85IMeV++d+vTBWOV9JDcjt5rdv6uw3M3uRR7pa/Xu+wBsOxA53bTnTP/3UX1b3fNQ1' +
  'BsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKqyr6d/97HIpchqZLlL8TUyjmxGnnXfo96DGYBRZD1ycpc/Xzbm' +
  'bvcV9e7tAByJPIys7fH3NyI3Ij/0tHrvtL8Hm1E24UXkxATXOB65GHkb+a6/1bsvA3A28jpyaArXOhy5GnluCNS7DwNQXni9jByc4jWXIucijyO' +
  '/9Lt6Zx6AV92mTFu5Mx2NPNHz6r2QdDOuRU7N8PqXJ3iBN0TV1jvjACxGbs9hnTv6Xr0zDsDqjB6K/1XuSCv6v+56ZxyA0UDXyqrqemccgLWBrp' +
  'VV1fXOOADLA10rq6rrnXEAVga6VlZV13uh8s1f1P911zvjAIznuJa3S1de79oHYKz/6653xgHYGuhaWVVd74wDsDHHtZ7q/7rrnXEA3s3pofJj5' +
  'LP+r7veGQfgd+T+HNZZ1/vqnfXfoA9mfLfYbNpD3FRe76wD8CdyJfJzBtcuD/fX9bx6F5kPxHyLfGnas6XT3OhR93wU9U5/JvhT99BcjtUtTXit' +
  '8gkFF5r2oDbq3YsB2N6UN5EzTXu8bi/eR85HPuhx9d6pTx+MVd5HcjNyq9n9uwrL3exe5JG+Vu++D8C2A5HTTXvO9H8f1bfVPQ9FvQEAAAAAAAA' +
  'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAgCn7C9HjBtwWfXpKAAAAAElFTkSuQmCC'

@Component
export struct TabTitleBar {
  tabItems: Array<TabTitleBarTabItem>
  menuItems: Array<TabTitleBarMenuItem>
  @BuilderParam swiperContent: () => void

  @State tabWidth: number = 0
  @State currentIndex: number = 0

  static readonly totalHeight = 56
  static readonly correctionOffset = -40.0
  static readonly gradientMaskWidth = 24
  private menuSectionWidth = 0

  private scroller: Scroller = new Scroller()
  private swiperController: SwiperController = new SwiperController()
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private leftContext2D: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private rightContext2D: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

  @Builder GradientMask(context2D: CanvasRenderingContext2D, x0: number, y0: number, x1: number, y1: number) {
    Column() {
      Canvas(context2D)
        .width(TabTitleBar.gradientMaskWidth)
        .height(TabTitleBar.totalHeight)
        .onReady(() => {
          var grad = context2D.createLinearGradient(x0, y0, x1, y1)
          grad.addColorStop(0.0, '#ffffffff')
          grad.addColorStop(1, '#00ffffff')
          context2D.fillStyle = grad
          context2D.fillRect(0, 0, TabTitleBar.gradientMaskWidth, TabTitleBar.totalHeight)
        })
    }
    .width(TabTitleBar.gradientMaskWidth)
    .height(TabTitleBar.totalHeight)
  }

  build() {
    Column() {
      Flex({
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Stretch
      }) {
        Stack({ alignContent: Alignment.End }) {
          Stack({ alignContent: Alignment.Start }) {
            Column() {
              List({ initialIndex: 0, scroller: this.scroller, space: 0 }) {
                ForEach(this.tabItems, (tabItem, index?: number) => {
                  ListItem() {
                    TabContentItem({
                      item: tabItem,
                      index: index,
                      maxIndex: this.tabItems.length - 1,
                      currentIndex: this.currentIndex,
                      onCustomClick: () => this.currentIndex = index
                    })
                  }
                })
              }
              .width('100%')
              .height(TabTitleBar.totalHeight)
              .constraintSize({ maxWidth: this.tabWidth })
              .edgeEffect(EdgeEffect.Spring)
              .listDirection(Axis.Horizontal)
              .scrollBar(BarState.Off)
            }
            this.GradientMask(this.leftContext2D, 0, TabTitleBar.totalHeight / 2,
              TabTitleBar.gradientMaskWidth, TabTitleBar.totalHeight / 2)
          }
          this.GradientMask(this.rightContext2D, TabTitleBar.gradientMaskWidth,
            TabTitleBar.totalHeight / 2, 0, TabTitleBar.totalHeight / 2)
        }

        if (this.menuItems !== undefined && this.menuItems.length > 0) {
          CollapsibleMenuSection({ menuItems: this.menuItems })
          .height(TabTitleBar.totalHeight)
          .onAreaChange((_oldValue: Area, newValue: Area) => {
            this.menuSectionWidth = Number(newValue.width)
          })
        }
      }
      .backgroundColor($r('sys.color.ohos_id_color_background'))
      .margin({ right: $r('sys.float.ohos_id_max_padding_end') })
      .onAreaChange((_oldValue: Area, newValue: Area) => {
        this.tabWidth = Number(newValue.width) - this.menuSectionWidth
      })

      Column() {
        Swiper(this.swiperController) { this.swiperContent() }
        .index(this.currentIndex)
        .itemSpace(0)
        .indicator(false)
        .width('100%')
        .height('100%')
        .curve(Curve.Friction)
        .onChange((index) => {
          this.currentIndex = index
          this.scroller.scrollToIndex(this.currentIndex)
          this.scroller.scrollBy(TabTitleBar.correctionOffset, 0)
        })
        .onAppear(() => {
          this.scroller.scrollToIndex(this.currentIndex)
          this.scroller.scrollBy(TabTitleBar.correctionOffset, 0)
        })
      }
    }
  }
}

@Component
struct CollapsibleMenuSection {
  menuItems: Array<TabTitleBarMenuItem>

  static readonly maxCountOfVisibleItems = 1
  private static readonly focusPadding = 4
  private static readonly marginsNum = 2

  @State isPopupShown: boolean = false

  @State isMoreIconOnFocus: boolean = false
  @State isMoreIconOnHover: boolean = false
  @State isMoreIconOnClick: boolean = false

  getMoreIconFgColor() {
    return this.isMoreIconOnClick
      ? $r('sys.color.ohos_id_color_titlebar_icon_pressed')
      : $r('sys.color.ohos_id_color_titlebar_icon')
  }

  getMoreIconBgColor() {
    if (this.isMoreIconOnClick) {
      return $r('sys.color.ohos_id_color_click_effect')
    } else if (this.isMoreIconOnHover) {
      return $r('sys.color.ohos_id_color_hover')
    } else {
      return Color.Transparent
    }
  }

  build() {
    Column() {
      Row() {
        if (this.menuItems.length <= CollapsibleMenuSection.maxCountOfVisibleItems) {
          ForEach(this.menuItems, (item) => {
            ImageMenuItem({ item: item })
          })
        } else {
          ForEach(this.menuItems.slice(0, CollapsibleMenuSection.maxCountOfVisibleItems - 1), (item) => {
            ImageMenuItem({ item: item })
          })

          Row() {
            Image(PUBLIC_MORE)
              .width(ImageMenuItem.imageSize)
              .height(ImageMenuItem.imageSize)
              .focusable(true)
          }
          .width(ImageMenuItem.imageHotZoneWidth)
          .height(ImageMenuItem.imageHotZoneWidth)
          .borderRadius(ImageMenuItem.buttonBorderRadius)
          .foregroundColor(this.getMoreIconFgColor())
          .backgroundColor(this.getMoreIconBgColor())
          .justifyContent(FlexAlign.Center)
          .border(this.isMoreIconOnFocus ?
            { width: ImageMenuItem.focusBorderWidth,
              color: $r('sys.color.ohos_id_color_emphasize'),
              style: BorderStyle.Solid
            } : { width: 0 })
          .onFocus(() => this.isMoreIconOnFocus = true)
          .onBlur(() => this.isMoreIconOnFocus = false)
          .onHover((isOn) => this.isMoreIconOnHover = isOn)
          .onKeyEvent((event) => {
            if (event.keyCode !== KeyCode.KEYCODE_ENTER && event.keyCode !== KeyCode.KEYCODE_SPACE) {
              return
            }
            if (event.type === KeyType.Down) {
              this.isMoreIconOnClick = true
            }
            if (event.type === KeyType.Up) {
              this.isMoreIconOnClick = false
            }
          })
          .onTouch((event) => {
            if (event.type === TouchType.Down) {
              this.isMoreIconOnClick = true
            }
            if (event.type === TouchType.Up) {
              this.isMoreIconOnClick = false
            }
          })
          .onClick(() => this.isPopupShown = true)
          .bindPopup(this.isPopupShown, {
            builder: this.popupBuilder,
            placement: Placement.Bottom,
            popupColor: Color.White,
            enableArrow: false,
            onStateChange: (e) => this.isPopupShown = e.isVisible
          })
        }
      }
    }
    .height('100%')
    // .margin({ right: $r('sys.float.ohos_id_default_padding_end') })
    .justifyContent(FlexAlign.Center)
  }

  @Builder popupBuilder() {
    Column() {
      ForEach(this.menuItems.slice(CollapsibleMenuSection.maxCountOfVisibleItems - 1, this.menuItems.length), (item, _index?) => {
        ImageMenuItem({ item: item })
      })
    }
    .width(ImageMenuItem.imageHotZoneWidth + CollapsibleMenuSection.focusPadding * CollapsibleMenuSection.marginsNum)
    .margin({ top: CollapsibleMenuSection.focusPadding, bottom: CollapsibleMenuSection.focusPadding })
  }
}

@Component
struct TabContentItem {
  item: TabTitleBarTabItem
  index: number
  maxIndex: number
  onCustomClick?: () => void

  @Prop currentIndex: number

  @State isOnFocus: boolean = false
  @State isOnHover: boolean = false
  @State isOnClick: boolean = false

  static readonly imageSize = 24
  static readonly imageHotZoneWidth = 48
  static readonly imageMagnificationFactor = 1.4
  static readonly buttonBorderRadius = 8
  static readonly focusBorderWidth = 2

  getBgColor() {
    if (this.isOnClick) {
      return $r('sys.color.ohos_id_color_click_effect')
    } else if (this.isOnHover) {
      return $r('sys.color.ohos_id_color_hover')
    } else {
      return Color.Transparent
    }
  }

  build() {
    Row() {
      Column() {
        if (this.item.icon === undefined) {
          Text(this.item.title)
            .fontSize(this.index === this.currentIndex
              ? $r('sys.float.ohos_id_text_size_headline7')
              : $r('sys.float.ohos_id_text_size_headline9'))
            .fontColor(this.index === this.currentIndex
              ? $r('sys.color.ohos_id_color_titlebar_text')
              : $r('sys.color.ohos_id_color_titlebar_text_off'))
            .fontWeight(FontWeight.Medium)
            .focusable(true)
            .padding({ top: this.index === this.currentIndex ? 6 : 10, left: 8, bottom: 2, right: 8 })
            .onFocus(() => this.isOnFocus = true)
            .onBlur(() => this.isOnFocus = false)
            .onHover((isOn) => this.isOnHover = isOn)
            .onKeyEvent((event) => {
              if (event.keyCode !== KeyCode.KEYCODE_ENTER && event.keyCode !== KeyCode.KEYCODE_SPACE) {
                return
              }
              if (event.type === KeyType.Down) {
                this.isOnClick = true
              }
              if (event.type === KeyType.Up) {
                this.isOnClick = false
              }
            })
            .onTouch((event) => {
              if (event.type === TouchType.Down) {
                this.isOnClick = true
              }
              if (event.type === TouchType.Up) {
                this.isOnClick = false
              }
            })
            .onClick(() => this.onCustomClick && this.onCustomClick())
        } else {
          Row() {
            Image(this.item.icon)
              .alt(this.item.title)
              .height(TabContentItem.imageSize)
              .focusable(true)
              .scale({
                x: this.index === this.currentIndex ? TabContentItem.imageMagnificationFactor : 1,
                y: this.index === this.currentIndex ? TabContentItem.imageMagnificationFactor : 1
              })
          }
          .width(TabContentItem.imageHotZoneWidth)
          .height(TabContentItem.imageHotZoneWidth)
          .justifyContent(FlexAlign.Center)
          .onFocus(() => this.isOnFocus = true)
          .onBlur(() => this.isOnFocus = false)
          .onHover((isOn) => this.isOnHover = isOn)
          .onKeyEvent((event) => {
            if (event.keyCode !== KeyCode.KEYCODE_ENTER && event.keyCode !== KeyCode.KEYCODE_SPACE) {
              return
            }
            if (event.type === KeyType.Down) {
              this.isOnClick = true
            }
            if (event.type === KeyType.Up) {
              this.isOnClick = false
            }
          })
          .onTouch((event) => {
            if (event.type === TouchType.Down) {
              this.isOnClick = true
            }
            if (event.type === TouchType.Up) {
              this.isOnClick = false
            }
          })
          .onClick(() => this.onCustomClick && this.onCustomClick())
        }
      }
      .justifyContent(FlexAlign.Center)
    }
    .height(TabTitleBar.totalHeight)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .margin({
      left: this.index === 0 ? 16 : 0,
      right: this.index === this.maxIndex ? 12 : 0
    })  // sys.float.ohos_id_max_padding_start - 8
    .borderRadius(TabContentItem.buttonBorderRadius)
    .backgroundColor(this.getBgColor())
    .border(this.isOnFocus ?
      { width: TabContentItem.focusBorderWidth,
        color: $r('sys.color.ohos_id_color_emphasize'),
        style: BorderStyle.Solid
      } : { width: 0 })
  }
}

@Component
struct ImageMenuItem {
  item: TabTitleBarMenuItem

  static readonly imageSize = 24
  static readonly imageHotZoneWidth = 48
  static readonly buttonBorderRadius = 8
  static readonly focusBorderWidth = 2
  static readonly disabledImageOpacity = 0.4

  @State isOnFocus: boolean = false
  @State isOnHover: boolean = false
  @State isOnClick: boolean = false

  getFgColor() {
    return this.isOnClick
      ? $r('sys.color.ohos_id_color_titlebar_icon_pressed')
      : $r('sys.color.ohos_id_color_titlebar_icon')
  }

  getBgColor() {
    if (this.isOnClick) {
      return $r('sys.color.ohos_id_color_click_effect')
    } else if (this.isOnHover) {
      return $r('sys.color.ohos_id_color_hover')
    } else {
      return Color.Transparent
    }
  }

  build() {
    Row() {
      Image(this.item.value)
        .width(ImageMenuItem.imageSize)
        .height(ImageMenuItem.imageSize)
        .focusable(this.item.isEnabled)
    }
    .width(ImageMenuItem.imageHotZoneWidth)
    .height(ImageMenuItem.imageHotZoneWidth)
    .borderRadius(ImageMenuItem.buttonBorderRadius)
    .foregroundColor(this.getFgColor())
    .backgroundColor(this.getBgColor())
    .justifyContent(FlexAlign.Center)
    .opacity(this.item.isEnabled ? 1 : ImageMenuItem.disabledImageOpacity)
    .border(this.isOnFocus ?
      { width: ImageMenuItem.focusBorderWidth,
        color: $r('sys.color.ohos_id_color_emphasize'),
        style: BorderStyle.Solid
      } : { width: 0 })
    .onFocus(() => {
      if (!this.item.isEnabled) {
        return
      }
      this.isOnFocus = true
    })
    .onBlur(() => this.isOnFocus = false)
    .onHover((isOn) => {
      if (!this.item.isEnabled) {
        return
      }
      this.isOnHover = isOn
    })
    .onKeyEvent((event) => {
      if (!this.item.isEnabled) {
        return
      }
      if (event.keyCode !== KeyCode.KEYCODE_ENTER && event.keyCode !== KeyCode.KEYCODE_SPACE) {
        return
      }
      if (event.type === KeyType.Down) {
        this.isOnClick = true
      }
      if (event.type === KeyType.Up) {
        this.isOnClick = false
      }
    })
    .onTouch((event) => {
      if (!this.item.isEnabled) {
        return
      }
      if (event.type === TouchType.Down) {
        this.isOnClick = true
      }
      if (event.type === TouchType.Up) {
        this.isOnClick = false
      }
    })
    .onClick(() => this.item.isEnabled && this.item.action && this.item.action())
  }
}

export default { TabTitleBar }