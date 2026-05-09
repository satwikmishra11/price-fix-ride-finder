from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.units import mm
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle,
    HRFlowable, PageBreak, KeepTogether
)
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.enums import TA_LEFT, TA_CENTER, TA_RIGHT
from reportlab.platypus import Flowable
from reportlab.pdfgen import canvas as rl_canvas

W, H = A4

# ── Colors ──────────────────────────────────────────────────────────
INK       = colors.HexColor('#09090b')
INK2      = colors.HexColor('#3f3f46')
INK3      = colors.HexColor('#71717a')
SURFACE   = colors.HexColor('#f4f4f5')
CARD      = colors.white
BORDER    = colors.HexColor('#e4e4e7')
BLUE      = colors.HexColor('#006FEE')
BLUE_SOFT = colors.HexColor('#EFF6FF')
ORANGE    = colors.HexColor('#FF6B2C')
ORG_SOFT  = colors.HexColor('#FFF4EE')
GREEN     = colors.HexColor('#17C964')
GRN_SOFT  = colors.HexColor('#EDFBF3')
PURPLE    = colors.HexColor('#7828C8')
PUR_SOFT  = colors.HexColor('#F5EEFF')
GOLD      = colors.HexColor('#C9A227')
RED       = colors.HexColor('#DC2626')
RED_SOFT  = colors.HexColor('#FEF2F2')
AMB_SOFT  = colors.HexColor('#FFFBEB')

# ── Styles ───────────────────────────────────────────────────────────
def S(name, **kw):
    base = dict(fontName='Helvetica', fontSize=10, textColor=INK,
                leading=15, spaceAfter=0, spaceBefore=0)
    base.update(kw)
    return ParagraphStyle(name, **base)

s_cover_title = S('ct', fontName='Helvetica-Bold', fontSize=32,
                  textColor=colors.white, leading=38, spaceAfter=6)
s_cover_sub   = S('cs', fontSize=12, textColor=colors.HexColor('#a1a1aa'),
                  leading=18, spaceAfter=0)
s_eyebrow     = S('ey', fontSize=8, textColor=colors.HexColor('#71717a'),
                  fontName='Helvetica', letterSpacing=1.5)
s_section_num = S('sn', fontSize=8, textColor=BLUE, fontName='Helvetica-Bold',
                  letterSpacing=1)
s_section_ttl = S('sh', fontName='Helvetica-Bold', fontSize=16, textColor=INK,
                  leading=20)
s_card_title  = S('ctt', fontName='Helvetica-Bold', fontSize=10, textColor=INK,
                  leading=14, spaceAfter=3)
s_body        = S('bd', fontSize=9, textColor=INK2, leading=14)
s_small       = S('sm', fontSize=8, textColor=INK3, leading=12)
s_code        = S('cd', fontName='Courier', fontSize=8, textColor=INK,
                  leading=12, backColor=SURFACE)
s_label       = S('lb', fontSize=7, textColor=INK3, fontName='Helvetica',
                  letterSpacing=0.8)
s_white       = S('wh', fontSize=9, textColor=colors.white, leading=14)
s_white_bold  = S('wb', fontName='Helvetica-Bold', fontSize=10,
                  textColor=colors.white, leading=14)
s_white_sm    = S('ws', fontSize=8, textColor=colors.HexColor('#a1a1aa'), leading=12)
s_mono        = S('mn', fontName='Courier', fontSize=8,
                  textColor=colors.HexColor('#1d4ed8'), leading=12)
s_tl_phase    = S('tp', fontSize=7, textColor=BLUE, fontName='Helvetica-Bold',
                  letterSpacing=0.8)
s_risk_h      = S('rh', fontSize=7, textColor=RED, fontName='Helvetica-Bold')
s_risk_m      = S('rm', fontSize=7, textColor=colors.HexColor('#b45309'),
                  fontName='Helvetica-Bold')
s_risk_l      = S('rl', fontSize=7, textColor=colors.HexColor('#065f46'),
                  fontName='Helvetica-Bold')
s_tag_blue    = S('tb', fontSize=7, textColor=colors.HexColor('#1d4ed8'),
                  fontName='Helvetica-Bold')
s_stat_num    = S('stn', fontName='Helvetica-Bold', fontSize=22,
                  textColor=BLUE, leading=26, alignment=TA_CENTER)
s_stat_lbl    = S('stl', fontSize=7, textColor=INK3, leading=10,
                  alignment=TA_CENTER)
s_h3          = S('h3', fontName='Helvetica-Bold', fontSize=11, textColor=INK,
                  leading=15, spaceAfter=4)
s_center      = S('sc', fontSize=9, textColor=INK2, alignment=TA_CENTER)
s_right       = S('sr', fontSize=9, textColor=INK2, alignment=TA_RIGHT)

# ── Helpers ──────────────────────────────────────────────────────────
def hr(color=BORDER, thick=0.5):
    return HRFlowable(width='100%', thickness=thick, color=color,
                      spaceAfter=8, spaceBefore=8)

def sp(h=6):
    return Spacer(1, h)

def P(text, style=None):
    return Paragraph(text, style or s_body)

class ColorRect(Flowable):
    def __init__(self, w, h, fill, radius=6):
        self.w, self.h, self.fill, self.radius = w, h, fill, radius
    def wrap(self, *a): return self.w, self.h
    def draw(self):
        self.canv.setFillColor(self.fill)
        self.canv.roundRect(0, 0, self.w, self.h, self.radius, fill=1, stroke=0)

def section_header(num, title, badge=None):
    rows = [[
        P(num, s_section_num),
        P(title, s_section_ttl),
        P(badge, S('b', fontSize=7, textColor=BLUE, fontName='Helvetica-Bold',
                   alignment=TA_RIGHT)) if badge else P('')
    ]]
    t = Table(rows, colWidths=[28, 360, 70])
    t.setStyle(TableStyle([
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('LINEBELOW', (0,0), (-1,0), 0.5, BORDER),
        ('BOTTOMPADDING', (0,0), (-1,-1), 8),
        ('TOPPADDING', (0,0), (-1,-1), 4),
    ]))
    return t

def info_card(title, body, accent=None):
    left_pad = 8
    inner_w = 458 - left_pad - 16
    rows = [[P(title, s_card_title)], [P(body, s_body)]]
    t = Table(rows, colWidths=[inner_w])
    t.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), CARD),
        ('BOX', (0,0), (-1,-1), 0.5, BORDER),
        ('ROUNDEDCORNERS', [8]),
        ('TOPPADDING', (0,0), (-1,-1), 8),
        ('BOTTOMPADDING', (0,0), (-1,-1), 8),
        ('LEFTPADDING', (0,0), (-1,-1), 12),
        ('RIGHTPADDING', (0,0), (-1,-1), 12),
    ]))
    return t

def two_col_cards(pairs):
    col_w = 225
    rows = []
    for i in range(0, len(pairs), 2):
        row = []
        for j in range(2):
            if i+j < len(pairs):
                ttl, bdy = pairs[i+j]
                inner = [[P(ttl, s_card_title)],[P(bdy, s_body)]]
                c = Table(inner, colWidths=[col_w - 24])
                c.setStyle(TableStyle([
                    ('BACKGROUND', (0,0), (-1,-1), CARD),
                    ('BOX', (0,0), (-1,-1), 0.5, BORDER),
                    ('ROUNDEDCORNERS', [6]),
                    ('TOPPADDING', (0,0), (-1,-1), 8),
                    ('BOTTOMPADDING', (0,0), (-1,-1), 8),
                    ('LEFTPADDING', (0,0), (-1,-1), 10),
                    ('RIGHTPADDING', (0,0), (-1,-1), 10),
                ]))
                row.append(c)
            else:
                row.append(P(''))
        rows.append(row)
    t = Table(rows, colWidths=[col_w, col_w], hAlign='LEFT')
    t.setStyle(TableStyle([
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('LEFTPADDING', (0,0), (-1,-1), 0),
        ('RIGHTPADDING', (0,0), (-1,-1), 0),
        ('TOPPADDING', (0,0), (-1,-1), 0),
        ('BOTTOMPADDING', (0,0), (-1,-1), 6),
        ('COLPADDING', (1,0), (1,-1), 6),
    ]))
    return t

def three_col_cards(triples):
    col_w = 148
    rows = []
    for i in range(0, len(triples), 3):
        row = []
        for j in range(3):
            if i+j < len(triples):
                ttl, bdy = triples[i+j]
                inner = [[P(ttl, s_card_title)],[P(bdy, s_body)]]
                c = Table(inner, colWidths=[col_w - 20])
                c.setStyle(TableStyle([
                    ('BACKGROUND', (0,0), (-1,-1), CARD),
                    ('BOX', (0,0), (-1,-1), 0.5, BORDER),
                    ('ROUNDEDCORNERS', [6]),
                    ('TOPPADDING', (0,0), (-1,-1), 7),
                    ('BOTTOMPADDING', (0,0), (-1,-1), 7),
                    ('LEFTPADDING', (0,0), (-1,-1), 9),
                    ('RIGHTPADDING', (0,0), (-1,-1), 9),
                ]))
                row.append(c)
            else:
                row.append(P(''))
        rows.append(row)
    t = Table(rows, colWidths=[col_w, col_w, col_w], hAlign='LEFT')
    t.setStyle(TableStyle([
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('LEFTPADDING', (0,0), (-1,-1), 0),
        ('RIGHTPADDING', (0,0), (-1,-1), 0),
        ('TOPPADDING', (0,0), (-1,-1), 0),
        ('BOTTOMPADDING', (0,0), (-1,-1), 5),
        ('COLPADDING', (1,0), (1,-1), 5),
        ('COLPADDING', (2,0), (2,-1), 5),
    ]))
    return t

def dark_card(title, items):
    col_w = 218
    rows = []
    for i in range(0, len(items), 2):
        row = []
        for j in range(2):
            if i+j < len(items):
                ttl, bdy = items[i+j]
                inner = [[P(ttl, s_white_bold)],[P(bdy, s_white_sm)]]
                c = Table(inner, colWidths=[col_w - 20])
                c.setStyle(TableStyle([
                    ('BACKGROUND', (0,0), (-1,-1), colors.HexColor('#18181b')),
                    ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor('#3f3f46')),
                    ('ROUNDEDCORNERS', [6]),
                    ('TOPPADDING', (0,0), (-1,-1), 8),
                    ('BOTTOMPADDING', (0,0), (-1,-1), 8),
                    ('LEFTPADDING', (0,0), (-1,-1), 10),
                    ('RIGHTPADDING', (0,0), (-1,-1), 10),
                ]))
                row.append(c)
            else:
                row.append(P(''))
        rows.append(row)
    container = [[P(title, S('dt', fontName='Helvetica-Bold', fontSize=11,
                             textColor=colors.white, leading=15,
                             spaceAfter=8))],
                 [Table(rows, colWidths=[col_w, col_w],
                        style=TableStyle([
                            ('VALIGN',(0,0),(-1,-1),'TOP'),
                            ('LEFTPADDING',(0,0),(-1,-1),0),
                            ('RIGHTPADDING',(0,0),(-1,-1),0),
                            ('TOPPADDING',(0,0),(-1,-1),0),
                            ('BOTTOMPADDING',(0,0),(-1,-1),5),
                            ('COLPADDING',(1,0),(1,-1),5),
                        ]))]]
    t = Table(container, colWidths=[458])
    t.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor('#09090b')),
        ('ROUNDEDCORNERS', [10]),
        ('TOPPADDING', (0,0), (-1,-1), 14),
        ('BOTTOMPADDING', (0,0), (-1,-1), 14),
        ('LEFTPADDING', (0,0), (-1,-1), 14),
        ('RIGHTPADDING', (0,0), (-1,-1), 14),
    ]))
    return t

def stat_row(stats):
    col_w = 148
    cells = []
    for num, lbl, col in stats:
        inner = [[P(num, S('sn2', fontName='Helvetica-Bold', fontSize=20,
                           textColor=col, leading=24, alignment=TA_CENTER))],
                 [P(lbl, s_stat_lbl)]]
        c = Table(inner, colWidths=[col_w - 16])
        c.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,-1), SURFACE),
            ('ROUNDEDCORNERS', [8]),
            ('TOPPADDING', (0,0), (-1,-1), 10),
            ('BOTTOMPADDING', (0,0), (-1,-1), 10),
            ('LEFTPADDING', (0,0), (-1,-1), 8),
            ('RIGHTPADDING', (0,0), (-1,-1), 8),
        ]))
        cells.append(c)
    t = Table([cells], colWidths=[col_w]*3, hAlign='LEFT')
    t.setStyle(TableStyle([
        ('VALIGN',(0,0),(-1,-1),'TOP'),
        ('LEFTPADDING',(0,0),(-1,-1),0),
        ('RIGHTPADDING',(0,0),(-1,-1),0),
        ('TOPPADDING',(0,0),(-1,-1),0),
        ('BOTTOMPADDING',(0,0),(-1,-1),0),
        ('COLPADDING',(1,0),(1,0),5),
        ('COLPADDING',(2,0),(2,0),5),
    ]))
    return t

def kpi_table(rows_data):
    headers = [
        P('Metric', s_label), P('Target', s_label),
        P('By', s_label), P('Priority', s_label)
    ]
    rows = [headers]
    for m, target, by, pri, col in rows_data:
        pc = S('pc', fontSize=7, textColor=col, fontName='Helvetica-Bold')
        rows.append([P(m, s_body), P(target, s_body), P(by, s_small), P(pri, pc)])
    t = Table(rows, colWidths=[200, 110, 70, 78])
    style = [
        ('LINEBELOW', (0,0), (-1,0), 0.5, BORDER),
        ('TOPPADDING', (0,0), (-1,-1), 7),
        ('BOTTOMPADDING', (0,0), (-1,-1), 7),
        ('LEFTPADDING', (0,0), (-1,-1), 0),
        ('RIGHTPADDING', (0,0), (-1,-1), 0),
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('BACKGROUND', (0,0), (-1,-1), CARD),
        ('BOX', (0,0), (-1,-1), 0.5, BORDER),
        ('ROUNDEDCORNERS', [8]),
        ('LEFTPADDING', (0,0), (-1,-1), 10),
    ]
    for i in range(1, len(rows)):
        style.append(('LINEBELOW', (0,i), (-1,i), 0.5, BORDER))
    t.setStyle(TableStyle(style))
    return t

def risk_table(items):
    rows = []
    for level, col, bg, name, mit in items:
        badge_s = S('rb', fontSize=7, textColor=col, fontName='Helvetica-Bold',
                    alignment=TA_CENTER)
        inner = [[P(level, badge_s)]]
        badge = Table(inner, colWidths=[44])
        badge.setStyle(TableStyle([
            ('BACKGROUND',(0,0),(-1,-1),bg),
            ('ROUNDEDCORNERS',[4]),
            ('TOPPADDING',(0,0),(-1,-1),4),
            ('BOTTOMPADDING',(0,0),(-1,-1),4),
        ]))
        text_col = [[P(name, s_card_title)],[P(mit, s_body)]]
        tc = Table(text_col, colWidths=[394])
        tc.setStyle(TableStyle([
            ('TOPPADDING',(0,0),(-1,-1),0),
            ('BOTTOMPADDING',(0,0),(-1,-1),0),
            ('LEFTPADDING',(0,0),(-1,-1),0),
            ('RIGHTPADDING',(0,0),(-1,-1),0),
        ]))
        rows.append([badge, tc])
    t = Table(rows, colWidths=[54, 404])
    t.setStyle(TableStyle([
        ('VALIGN',(0,0),(-1,-1),'TOP'),
        ('BACKGROUND',(0,0),(-1,-1),CARD),
        ('BOX',(0,0),(-1,-1),0.5,BORDER),
        ('ROUNDEDCORNERS',[8]),
        ('TOPPADDING',(0,0),(-1,-1),8),
        ('BOTTOMPADDING',(0,0),(-1,-1),8),
        ('LEFTPADDING',(0,0),(-1,-1),10),
        ('RIGHTPADDING',(0,0),(-1,-1),6),
        ('LINEBELOW',(0,0),(-1,-2),0.5,BORDER),
    ]))
    return t

def code_block(lines):
    text = '<br/>'.join(lines)
    inner = [[P(text, s_code)]]
    t = Table(inner, colWidths=[458])
    t.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,-1),SURFACE),
        ('BOX',(0,0),(-1,-1),0.5,BORDER),
        ('ROUNDEDCORNERS',[6]),
        ('TOPPADDING',(0,0),(-1,-1),10),
        ('BOTTOMPADDING',(0,0),(-1,-1),10),
        ('LEFTPADDING',(0,0),(-1,-1),12),
        ('RIGHTPADDING',(0,0),(-1,-1),12),
    ]))
    return t

def highlight(text, color=BLUE):
    inner = [[P(text, S('hi', fontSize=10, textColor=INK2, leading=15))]]
    t = Table(inner, colWidths=[436])
    t.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,-1),CARD),
        ('LINEBEFORE',(0,0),(0,-1),3,color),
        ('BOX',(0,0),(-1,-1),0.5,BORDER),
        ('ROUNDEDCORNERS',[0,8,8,0]),
        ('TOPPADDING',(0,0),(-1,-1),10),
        ('BOTTOMPADDING',(0,0),(-1,-1),10),
        ('LEFTPADDING',(0,0),(-1,-1),14),
        ('RIGHTPADDING',(0,0),(-1,-1),12),
    ]))
    return t

# ── Page template ─────────────────────────────────────────────────────
PAGE_NUM = [0]

def on_page(canvas, doc):
    PAGE_NUM[0] += 1
    n = PAGE_NUM[0]
    canvas.saveState()
    if n == 1:
        canvas.setFillColor(INK)
        canvas.roundRect(30, H-200, W-60, 175, 12, fill=1, stroke=0)
        canvas.setFillColor(BLUE)
        canvas.roundRect(30, H-200, 6, 175, 3, fill=1, stroke=0)
        canvas.setFillColor(colors.HexColor('#1d4ed8'))
        canvas.circle(W-80, H-55, 55, fill=1, stroke=0)
        canvas.setFillColor(ORANGE)
        canvas.circle(W-95, H-165, 25, fill=1, stroke=0)
    if n > 1:
        canvas.setFillColor(SURFACE)
        canvas.rect(0, H-36, W, 36, fill=1, stroke=0)
        canvas.setFillColor(BLUE)
        canvas.rect(0, H-36, 4, 36, fill=1, stroke=0)
        canvas.setFont('Helvetica-Bold', 7)
        canvas.setFillColor(INK3)
        canvas.drawString(50, H-22, 'RIDESCOUT · FULL PRD & TECHNICAL SPEC · CONFIDENTIAL')
        canvas.drawRightString(W-30, H-22, f'Page {n}')
        canvas.setFillColor(SURFACE)
        canvas.rect(0, 0, W, 30, fill=1, stroke=0)
        canvas.setFont('Helvetica', 7)
        canvas.setFillColor(INK3)
        canvas.drawString(30, 10, 'RideScout v2.0 · Apple-First · Internal Document')
        canvas.drawRightString(W-30, 10, 'Confidential — Do Not Distribute')
    canvas.restoreState()

# ── Build story ───────────────────────────────────────────────────────
story = []

# ── COVER ────────────────────────────────────────────────────────────
story += [
    sp(14),
    P('PRODUCT REQUIREMENTS DOCUMENT + TECHNICAL SPECIFICATION', s_eyebrow),
    sp(10),
    P('RideScout', s_cover_title),
    P('Full-Fledged iOS Ride Intelligence Platform', S('cs2', fontName='Helvetica',
      fontSize=16, textColor=colors.HexColor('#ff6b2c'), leading=20)),
    sp(8),
    P('The definitive ride comparison platform for Apple users — every fare, every platform, '
      'every transit option, unified in a single beautifully crafted iOS experience. '
      'This document covers the complete product specification and backend technical architecture.',
      s_cover_sub),
    sp(20),
]
meta_rows = [[
    P('Product\nRideScout v2.0', S('m', fontSize=9, textColor=colors.white, leading=14)),
    P('Platform\niOS · watchOS · CarPlay · iPad', S('m', fontSize=9, textColor=colors.white, leading=14)),
    P('Status\nFull Spec · In Review', S('m', fontSize=9, textColor=colors.white, leading=14)),
    P('Market\nIndia + Southeast Asia', S('m', fontSize=9, textColor=colors.white, leading=14)),
]]
mt = Table(meta_rows, colWidths=[114]*4)
mt.setStyle(TableStyle([
    ('LINEABOVE', (0,0), (-1,0), 0.5, colors.HexColor('#3f3f46')),
    ('TOPPADDING', (0,0), (-1,-1), 10),
    ('BOTTOMPADDING', (0,0), (-1,-1), 8),
    ('LEFTPADDING', (0,0), (-1,-1), 0),
    ('RIGHTPADDING', (0,0), (-1,-1), 0),
    ('VALIGN', (0,0), (-1,-1), 'TOP'),
]))
story += [mt, PageBreak()]

# ─────────────────────────────────────────────────────────────────────
# PART 1: PRODUCT REQUIREMENTS DOCUMENT
# ─────────────────────────────────────────────────────────────────────
story += [
    sp(10),
    P('PART 1', s_eyebrow),
    sp(4),
    P('Product Requirements Document', S('ph', fontName='Helvetica-Bold', fontSize=22,
      textColor=INK, leading=28)),
    hr(BLUE, 2), sp(8),
]

# 01 Executive Summary
story += [section_header('01', 'Executive Summary'), sp(6),
    highlight('RideScout is a premium iOS-native ride intelligence app that aggregates real-time fares, '
              'ETAs, and availability across all ride-hailing and public transit platforms. Users search '
              'once, see everything, book instantly — with full Apple ecosystem depth: Watch, CarPlay, '
              'Siri, Live Activities, Apple Wallet, and on-device ML. Built from ground up in SwiftUI, '
              'not a web wrapper.'), sp(8),
    stat_row([('₹800+','avg monthly overspend per commuter',BLUE),
              ('4.3 min','wasted per trip switching apps',ORANGE),
              ('62M','iPhone users in India — TAM',GREEN)]),
    sp(12),
]

# 02 Problem
story += [section_header('02', 'Problem Space'), sp(6),
    two_col_cards([
        ('Fragmented discovery','Commuters open 4–6 apps before every booking. Each requires separate location entry, independent loading, and shows no cross-platform context.'),
        ('Invisible surge penalties','Surge can inflate fares 2–4x but users cannot compare surge states across platforms simultaneously or be alerted when one normalises.'),
        ('Public transit blindness','Metro, BEST, BMTC, DTC options never surface alongside private rides. The cheapest ₹30 metro route is invisible when browsing ₹350 cabs.'),
        ('Zero spend intelligence','No app aggregates cross-platform spend history. Users do not know their monthly ride spend or which platform saves them money per route.'),
    ]), sp(12),
]

# 03 Platforms
story += [section_header('03', 'Integrated Platforms', '15+ services'), sp(6)]
plat_data = [
    ['Uber','UberGo · Premier · XL · Moto · Auto · Connect'],
    ['Ola','Mini · Sedan · Prime · SUV · Auto · Bike · Outstation'],
    ['Rapido','Bike Taxi · Auto · Cab · Rapido Plus'],
    ['InDrive','Bid-your-price rides · Intercity'],
    ['Namma Yatri','Auto · Cab (Bengaluru, Kochi, Mysuru)'],
    ['BluSmart','Electric cabs — Delhi, Bengaluru'],
    ['Metro GTFS','DMRC · BMRCL · Chennai · Hyderabad · Mumbai'],
    ['City Buses','BEST · BMTC · DTC · TSRTC via GTFS feeds'],
    ['Shared Pools','Uber Pool · Ola Share · Quick Ride'],
    ['Phase 2','Yulu · Bounce · Zoom Car · redBus · Meru · IRCTC'],
]
ph = [[P('Platform', s_label), P('Service Tiers', s_label)]]
pr = [[P(a, s_card_title), P(b, s_body)] for a,b in plat_data]
pt = Table(ph+pr, colWidths=[100, 358])
pt.setStyle(TableStyle([
    ('BACKGROUND',(0,0),(-1,-1),CARD),
    ('BOX',(0,0),(-1,-1),0.5,BORDER),
    ('ROUNDEDCORNERS',[8]),
    ('LINEBELOW',(0,0),(-1,0),0.5,BORDER),
    ('TOPPADDING',(0,0),(-1,-1),7),('BOTTOMPADDING',(0,0),(-1,-1),7),
    ('LEFTPADDING',(0,0),(-1,-1),10),('RIGHTPADDING',(0,0),(-1,-1),10),
    *[('LINEBELOW',(0,i),(-1,i),0.5,BORDER) for i in range(1,len(pr))],
]))
story += [pt, sp(12)]

# 04 Users
story += [section_header('04', 'Target Users & Personas'), sp(6)]
personas = [
    ('AR','Arjun R., 26 — Daily Power Commuter',
     'Software Engineer · Bengaluru · iPhone 15 Pro',
     'Takes 2 rides daily, spends ₹4,000+/month. Expects Face ID on launch and Apple Pay at checkout. Watches surge alerts on Apple Watch during meetings. Needs cheapest option in under 10 seconds.'),
    ('PS','Priya S., 35 — Safety-First Professional',
     'Marketing Director · Mumbai · iPhone 16 Pro Max',
     'Books rides for client meetings and late-night returns. Needs safety scores, live-share with family via iMessage, rated drivers. Uses Siri: "Hey Siri, book me a cab to BKC."'),
    ('KT','Kavya T., 29 — Eco-Conscious Explorer',
     'UX Designer · Hyderabad · iPhone 15 + iPad',
     'Prefers Metro + e-bike combos, tracks CO2 saved. Shares split costs via Apple Pay Cash with flatmates. Uses iPad version for weekly commute planning sessions.'),
    ('MK','Mohan K., 42 — Business Traveller',
     'Sales VP · Delhi · iPhone 16 + CarPlay',
     'Needs airport transfer options, corporate travel receipts, GST invoices in Apple Wallet. Uses Siri Shortcuts to auto-book his regular airport route.'),
]
for init, name, role, need in personas:
    row = [[P(init, S('av', fontName='Helvetica-Bold', fontSize=11,
                      textColor=BLUE, alignment=TA_CENTER)),
            [P(name, s_card_title), P(role, s_small), sp(3), P(need, s_body)]]]
    pt2 = Table(row, colWidths=[40, 418])
    pt2.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,-1),CARD),
        ('BOX',(0,0),(-1,-1),0.5,BORDER),
        ('ROUNDEDCORNERS',[8]),
        ('TOPPADDING',(0,0),(-1,-1),10),('BOTTOMPADDING',(0,0),(-1,-1),10),
        ('LEFTPADDING',(0,0),(-1,-1),10),('RIGHTPADDING',(0,0),(-1,-1),10),
        ('VALIGN',(0,0),(-1,-1),'TOP'),
        ('BACKGROUND',(0,0),(0,-1),BLUE_SOFT),
    ]))
    story += [pt2, sp(5)]
story.append(sp(8))

# 05 Features
story += [section_header('05', 'Full Feature Set'), sp(6),
    P('Core — Ride Intelligence', s_h3), sp(4),
    two_col_cards([
        ('Universal fare search','Enter origin + destination once. Every available ride type across 15+ platforms in a single ranked list. Auto-refreshes every 60s on active view.'),
        ('Surge intelligence engine','Real-time surge multiplier per platform. Historical heatmap by hour and day. Predictive "surge-free window" alert on Watch when a platform drops below 1.2x.'),
        ('Multi-modal route builder','Blended journeys: Metro + cab, bus + bike, walk + auto. Shows total cost, total time, CO2 vs full-cab alternative for every combination.'),
        ('Deep-link booking handoff','One tap pre-fills pickup/drop in target app via Universal Links for Uber, Ola, Rapido, Namma Yatri. No retyping. Confirmed via receipt parsing.'),
    ]),sp(6),
    P('Apple Ecosystem — Native Integrations', s_h3), sp(4),
    dark_card('Built for the full Apple stack', [
        ('Apple Watch app','Fare comparison on wrist. Surge alert complications. One-tap "book cheapest" action. Live Activity mirror for ride tracking.'),
        ('CarPlay dashboard','Full fare search in CarPlay-native UI. Voice-first with Siri. Hands-free booking. Nearest pickup points while driving.'),
        ('Live Activities + Dynamic Island','Post-booking Live Activity shows driver ETA, plate, real-time position. Dynamic Island compact view on iPhone 14 Pro+.'),
        ('Apple Wallet passes','Metro QR tickets, booking confirmations, GST receipts as Wallet passes. Auto-updated with boarding details on trip day.'),
        ('Siri & Shortcuts','Full SiriKit + App Shortcuts for iOS 17. "Hey Siri, cheapest ride to airport." User automations: "Every Friday at 5pm, search rides home."'),
        ('Apple Pay & Cash','Premium subscription via Apple Pay. Group cost split as Apple Cash requests. One-tap GST invoice PDF download.'),
        ('Calendar-aware suggestions','Reads Apple Calendar. 45 min before a meeting, surfaces fare comparison with live-traffic buffer built in.'),
        ('Apple Maps integration','RideScout appears as ride option within Apple Maps. Tapping "Get Directions" shows fare estimates from RideScout inline.'),
    ]),sp(6),
    P('Intelligence & Personalisation', s_h3), sp(4),
    two_col_cards([
        ('Smart commute learning (Core ML)','Detects recurring routes on-device via Core ML. Proactively surfaces fare comparison for usual commute at typical departure time each morning.'),
        ('Cross-platform spend analytics','Aggregates spend across all platforms via receipt parsing from Apple Mail + manual entry. Weekly and monthly breakdowns with Work/Personal category tags.'),
        ('Carbon footprint tracker','CO2 per trip by vehicle type and distance. Cumulative eco savings from Metro and e-bike choices. Shareable monthly eco report card.'),
        ('Driver trust scoring','Aggregated driver ratings across platforms. Flags unrated or below-3.8-star drivers. "Trusted driver" mode filters out low-rated options.'),
        ('Live trip share via iMessage','Real-time trip progress, driver info, and ETA shared to any iMessage contact. iCloud-backed position relay. No account required for recipient.'),
        ('Group cost split','Split fare estimate among up to 8 contacts. Apple Cash payment requests directly from split screen before the ride is booked.'),
    ]),sp(12),
]

# 06 Business Model
story += [section_header('06', 'Business Model'), sp(6)]
biz_data = [
    ['Free', '₹0 / month',
     'Unlimited fare searches, deep-link booking, basic surge view, Metro + bus routes, CO2 tracker. Revenue via affiliate commission ₹8–25 per booked ride referral.'],
    ['Scout Pro ★', '₹149 / month',
     'Everything in Free + surge prediction alerts, spend analytics, calendar integration, driver trust filters, receipt export, 30s refresh rate, Apple Watch app, priority support.'],
    ['Business', '₹499 / month',
     'Everything in Pro + multi-user team dashboard, corporate policy engine (max fare caps), GST invoice aggregation, ERP integrations (Zoho, SAP), dedicated SLA.'],
]
bh = [[P('Tier', s_label), P('Price', s_label), P('Inclusions', s_label)]]
br = [[P(a, s_card_title), P(b, S('bp', fontName='Helvetica-Bold', fontSize=10,
         textColor=BLUE)), P(c, s_body)] for a,b,c in biz_data]
bt = Table(bh+br, colWidths=[80, 80, 298])
bt.setStyle(TableStyle([
    ('BACKGROUND',(0,0),(-1,-1),CARD),
    ('BOX',(0,0),(-1,-1),0.5,BORDER),
    ('ROUNDEDCORNERS',[8]),
    ('LINEBELOW',(0,0),(-1,0),0.5,BORDER),
    ('BACKGROUND',(0,2),(-1,2),BLUE_SOFT),
    ('TOPPADDING',(0,0),(-1,-1),8),('BOTTOMPADDING',(0,0),(-1,-1),8),
    ('LEFTPADDING',(0,0),(-1,-1),10),('RIGHTPADDING',(0,0),(-1,-1),10),
    ('LINEBELOW',(0,1),(-1,2),0.5,BORDER),
    ('VALIGN',(0,0),(-1,-1),'TOP'),
]))
story += [bt, sp(6),
    info_card('Additional revenue streams',
              'Platform-sponsored "Highlighted" badges (Uber/Ola pay for featured placement in non-surge results) · '
              'Ride insurance upsell (Digit, HDFC ERGO in-app policies) · '
              'Data insights API for urban planners (anonymised, aggregated, opt-in only) · '
              'White-label SDK licensing for travel super-apps.'),
    sp(12),
]

# 07 KPIs
story += [section_header('07', 'Success Metrics & KPIs'), sp(6),
    kpi_table([
        ('Monthly Active Users','1M MAU','Month 9','Critical',RED),
        ('Search → deep-link conversion','>60%','Month 3','Critical',RED),
        ('D30 retention rate','>42%','Month 6','Critical',RED),
        ('App Store rating','≥4.6 stars','Month 4','High',ORANGE),
        ('Pro subscription conversion','>12% of MAU','Month 6','High',ORANGE),
        ('Avg. fare load time (p50)','<1.8s','Month 1','Critical',RED),
        ('Watch app DAU / iPhone DAU','>25%','Month 8','Growth',GREEN),
        ('Monthly revenue (all streams)','Rs.5Cr/mo','Month 15','Long-term',BLUE),
        ('Crash-free session rate','>=99.5%','Month 1','Critical',RED),
        ('Corporate accounts (Biz tier)','500 companies','Month 14','Long-term',BLUE),
    ]),sp(12),
]

# 08 Roadmap
story += [section_header('08', 'Product Roadmap — 18 Months'), sp(6)]
roadmap = [
    ('Q1 2026', 'Foundation — Core App Launch',
     '4 cities (Bengaluru, Mumbai, Delhi, Hyderabad). Uber + Ola + Rapido + Metro. Deep-link booking, Apple Pay subscription, Live Activities, Apple Wallet pass support, App Store launch with ratings campaign.'),
    ('Q2 2026', 'Ecosystem Depth — Watch + CarPlay + Siri',
     'watchOS 10 app, CarPlay entitlement, SiriKit, App Shortcuts for iOS 17, calendar event ride suggestions, 8-city expansion (Chennai, Pune, Kolkata, Ahmedabad). BluSmart + Namma Yatri integration.'),
    ('Q3 2026', 'Intelligence — Core ML + Analytics + iPad',
     'On-device commute pattern learning, predictive surge alerts, full cross-platform spend dashboard, CO2 report card, iPadOS multi-column layout, Yulu + Bounce + InDrive added.'),
    ('Q4 2026', 'Business & International Expansion',
     'Corporate fleet policy engine, ERP integrations (Zoho, SAP), GST receipt Wallet pass, launch in Singapore and Kuala Lumpur with Grab and Gojek integration.'),
    ('2027', 'Platform — Apple Maps + SDK',
     'Native Apple Maps ride option powered by RideScout, open SDK for travel apps, inter-city rail + bus aggregation, real-time accessibility info, AirPods Pro voice-first mode.'),
]
for phase, title, desc in roadmap:
    row = [[P(phase, S('rp', fontSize=8, textColor=BLUE, fontName='Helvetica-Bold',
                       letterSpacing=0.5)),
            [P(title, s_card_title), sp(2), P(desc, s_body)]]]
    rt = Table(row, colWidths=[70, 388])
    rt.setStyle(TableStyle([
        ('BACKGROUND',(0,0),(-1,-1),CARD),
        ('BOX',(0,0),(-1,-1),0.5,BORDER),
        ('ROUNDEDCORNERS',[8]),
        ('TOPPADDING',(0,0),(-1,-1),9),('BOTTOMPADDING',(0,0),(-1,-1),9),
        ('LEFTPADDING',(0,0),(-1,-1),10),('RIGHTPADDING',(0,0),(-1,-1),10),
        ('VALIGN',(0,0),(-1,-1),'TOP'),
        ('BACKGROUND',(0,0),(0,-1),BLUE_SOFT),
        ('LINEAFTER',(0,0),(0,-1),0.5,BORDER),
    ]))
    story += [rt, sp(5)]
story.append(sp(8))

# 09 Risks
story += [section_header('09', 'Risks & Mitigations'), sp(6),
    risk_table([
        ('Critical', RED, RED_SOFT, 'Platform API access gated or revoked',
         'Maintain three integration modes per platform: official affiliate API (preferred), structured scraping (fallback), manual fare tables every 4h (last resort). Proactively pitch Uber/Ola on revenue-sharing partnership for API access.'),
        ('Critical', RED, RED_SOFT, 'Apple Maps integration approval uncertain',
         'Apply to Apple Maps partner programme Q1 2026. Build as deferred feature (Q4 roadmap) rather than dependency. App functions fully standalone without this integration.'),
        ('High', colors.HexColor('#b45309'), AMB_SOFT, 'Stale fares erode user trust',
         'Display data freshness timestamp prominently. Animated shimmer when refreshing. Disclaimer on booking handoff: "Fares may differ at booking time." p95 refresh SLA of 90 seconds.'),
        ('High', colors.HexColor('#b45309'), AMB_SOFT, 'Low Pro tier conversion',
         'Free tier deliberately excludes surge alerts and spend analytics — highest-value features for daily users. A/B test paywall placement: post-second-surge vs. day-7 nudge. 3-month free trial for new users.'),
        ('Medium', colors.HexColor('#065f46'), GRN_SOFT, 'Location data regulatory scrutiny',
         'On-device location processing only via Core Location — never transmitted. DPDP Act 2023 + GDPR compliant. Quarterly privacy audits. Transparent data dashboard in Settings.'),
    ]),
    sp(16), PageBreak(),
]

# ─────────────────────────────────────────────────────────────────────
# PART 2: TECHNICAL SPECIFICATION
# ─────────────────────────────────────────────────────────────────────
story += [
    sp(10),
    P('PART 2', s_eyebrow),
    sp(4),
    P('Fare Aggregation Backend — Technical Specification', S('ph', fontName='Helvetica-Bold',
      fontSize=20, textColor=INK, leading=26)),
    hr(ORANGE, 2), sp(8),
]

# T01 Overview
story += [section_header('T01', 'System Overview'), sp(6),
    highlight('The RideScout backend is a horizontally scalable, event-driven microservices system '
              'deployed on AWS. Its primary responsibility is fetching, normalising, caching, and '
              'serving real-time fare data from 15+ ride platforms and GTFS transit feeds — '
              'all within a 1.8s p50 latency budget from client request to rendered result.',
              ORANGE),
    sp(8),
    stat_row([('1.8s','p50 fare load latency target',ORANGE),
              ('60s','Redis cache TTL per route',BLUE),
              ('99.7%','uptime SLA for aggregation layer',GREEN)]),
    sp(12),
]

# T02 Architecture
story += [section_header('T02', 'Architecture Overview'), sp(6)]
arch_layers = [
    ('iOS Client (SwiftUI)', 'URLSession async/await → REST + WebSocket. On-device caching via Core Data. Optimistic UI with shimmer states during fetch. Background refresh via BGTaskScheduler.'),
    ('API Gateway (AWS API GW + CloudFront)', 'TLS termination, rate limiting (100 req/min per device), JWT validation (Apple Sign-In tokens), request routing to fare-aggregation service.'),
    ('Fare Aggregation Service (Node.js)', 'Primary microservice. Fans out parallel requests to all platform adapters. Normalises responses into canonical FareResult schema. Returns merged array sorted by price. Deployed on ECS Fargate.'),
    ('Platform Adapter Layer', 'One adapter per platform (Uber, Ola, Rapido, etc.). Each adapter handles auth, request formation, response parsing, and error classification. Isolated failures — one adapter down does not affect others.'),
    ('Redis Cache Cluster', 'AWS ElastiCache Redis. Key: SHA256(origin_lat, origin_lng, dest_lat, dest_lng, platform). TTL: 60s standard, 30s during detected surge events. Read-through pattern from aggregation service.'),
    ('Kafka Event Bus', 'Real-time surge state change events published by adapters. Consumed by: surge prediction service, push notification service, analytics pipeline. Partitioned by city.'),
    ('GTFS Transit Service', 'Separate Node.js service. Ingests GTFS static + GTFS-RT feeds for Metro and bus networks. Refreshes static data every 24h, real-time positions every 15s. Exposes unified transit fare + schedule endpoint.'),
    ('Surge Prediction Service (Python)', 'Consumes Kafka surge events. XGBoost model trained on 6-month historical fare data per city-hour. Publishes surge_forecast events. Triggers APNs push via notification service.'),
    ('Push Notification Service', 'Node.js + AWS SNS → APNs. Sends surge drop alerts and calendar-triggered ride suggestions. Respects user Focus mode state (stored in profile service).'),
    ('Data Warehouse (Redshift + S3)', 'Anonymised, aggregated fare data pipeline via Kinesis Firehose → S3 → Redshift. Powers BI dashboard, surge model retraining, and (opt-in) data insights API for urban planners.'),
]
ah = [[P('Service', s_label), P('Responsibility', s_label)]]
ar = [[P(a, s_card_title), P(b, s_body)] for a,b in arch_layers]
at = Table(ah+ar, colWidths=[160, 298])
at.setStyle(TableStyle([
    ('BACKGROUND',(0,0),(-1,-1),CARD),
    ('BOX',(0,0),(-1,-1),0.5,BORDER),
    ('ROUNDEDCORNERS',[8]),
    ('LINEBELOW',(0,0),(-1,0),0.5,BORDER),
    ('TOPPADDING',(0,0),(-1,-1),7),('BOTTOMPADDING',(0,0),(-1,-1),7),
    ('LEFTPADDING',(0,0),(-1,-1),10),('RIGHTPADDING',(0,0),(-1,-1),10),
    ('VALIGN',(0,0),(-1,-1),'TOP'),
    *[('LINEBELOW',(0,i),(-1,i),0.5,BORDER) for i in range(1,len(ar))],
    *[('BACKGROUND',(0,i),(-1,i),SURFACE) for i in range(1,len(ar)+1,2)],
]))
story += [at, sp(12)]

# T03 API Schema
story += [section_header('T03', 'Core API — Fare Search Endpoint'), sp(6),
    P('Request', s_h3), sp(4),
    code_block([
        'POST /v1/fares/search',
        'Authorization: Bearer <apple_sign_in_jwt>',
        'Content-Type: application/json',
        '',
        '{',
        '  "origin":      { "lat": 12.9716, "lng": 77.5946 },',
        '  "destination": { "lat": 12.9352, "lng": 77.6245 },',
        '  "platforms":   ["uber","ola","rapido","metro","bus"],',
        '  "preferences": { "min_rating": 4.0, "max_fare": 500 },',
        '  "client_ts":   "2026-05-09T10:30:00+05:30"',
        '}',
    ]), sp(8),
    P('Response', s_h3), sp(4),
    code_block([
        'HTTP 200 OK',
        '',
        '{',
        '  "request_id": "req_01J2XK...",',
        '  "fetched_at": "2026-05-09T10:30:01.243Z",',
        '  "results": [',
        '    {',
        '      "platform": "rapido",',
        '      "service_type": "bike_taxi",',
        '      "fare": { "amount": 52, "currency": "INR", "surge_multiplier": 1.0 },',
        '      "eta_minutes": 3,',
        '      "vehicle": { "type": "bike", "seats": 1 },',
        '      "driver_rating": 4.7,',
        '      "deep_link": "rapido://book?pickup=12.9716,77.5946&drop=12.9352,77.6245",',
        '      "co2_grams": 18,',
        '      "cache_age_seconds": 22',
        '    },',
        '    { "platform": "metro", "service_type": "transit", ... },',
        '    { "platform": "uber", "service_type": "ubergo", ... }',
        '  ],',
        '  "surge_summary": { "uber": 1.4, "ola": 1.0, "rapido": 1.0 },',
        '  "transit_options": [ { "mode": "metro+walk", "total_fare": 30, ... } ]',
        '}',
    ]), sp(12),
]

# T04 Platform Adapters
story += [section_header('T04', 'Platform Adapter Specification'), sp(6),
    info_card('Adapter contract',
              'Every platform adapter implements the PlatformAdapter interface. It receives a normalised '
              'SearchRequest and must return FareResult[] within 1.5s or throw a TimeoutError. '
              'The aggregation service wraps every adapter call in Promise.allSettled() — partial results '
              'are returned to the client with platform-level error states, never a 500.'),
    sp(6),
    P('Adapter integration modes (per platform)', s_h3), sp(4),
]
adapter_data = [
    ['Uber','Official Affiliate API','Bearer token, daily rotation','Real-time, 5s freshness'],
    ['Ola','Partner API (v2)','OAuth 2.0, 1h expiry','Real-time, 10s freshness'],
    ['Rapido','Affiliate deep-link API','API key, static','Fare estimate, ~30s freshness'],
    ['InDrive','Screen-scraping (fallback)','Session cookie rotation','~60s freshness'],
    ['Namma Yatri','Open API (ONDC)','No auth required','Real-time'],
    ['BluSmart','Partner API (MoU required)','API key','Real-time'],
    ['Metro GTFS','GTFS-RT feed (public)','No auth','15s real-time position'],
    ['BEST/BMTC Bus','GTFS static + RT','No auth','15s real-time position'],
]
ah2 = [[P(h, s_label) for h in ['Platform','Integration Mode','Auth','Data Freshness']]]
ar2 = [[P(a, s_card_title), P(b, s_body), P(c, s_small), P(d, s_small)]
       for a,b,c,d in adapter_data]
at2 = Table(ah2+ar2, colWidths=[70, 140, 130, 118])
at2.setStyle(TableStyle([
    ('BACKGROUND',(0,0),(-1,-1),CARD),
    ('BOX',(0,0),(-1,-1),0.5,BORDER),
    ('ROUNDEDCORNERS',[8]),
    ('LINEBELOW',(0,0),(-1,0),0.5,BORDER),
    ('TOPPADDING',(0,0),(-1,-1),7),('BOTTOMPADDING',(0,0),(-1,-1),7),
    ('LEFTPADDING',(0,0),(-1,-1),10),('RIGHTPADDING',(0,0),(-1,-1),10),
    ('VALIGN',(0,0),(-1,-1),'TOP'),
    *[('LINEBELOW',(0,i),(-1,i),0.5,BORDER) for i in range(1,len(ar2))],
]))
story += [at2, sp(12)]

# T05 Caching
story += [section_header('T05', 'Caching Strategy'), sp(6),
    two_col_cards([
        ('Cache key design',
         'SHA256(floor(lat*1000)/1000, floor(lng*1000)/1000, dest_lat, dest_lng, platform). '
         'Lat/lng floored to 3 decimal places (~110m grid) to maximise hit rate for nearby pickups.'),
        ('TTL policy',
         'Standard: 60s. Surge detected (multiplier >1.2x): 30s. Off-peak hours (11pm–6am): 120s. '
         'GTFS transit data: 15s (RT positions), 24h (static schedules).'),
        ('Cache warming',
         'Top 200 city routes pre-warmed every 45s by a scheduled Lambda. Reduces cold-start latency for '
         'common airport, station, and CBD routes to near-zero.'),
        ('Eviction & memory',
         'Redis maxmemory-policy: allkeys-lru. Per-city cluster to prevent cross-city eviction pressure. '
         'Alert threshold at 80% memory — triggers auto-scaling of cache nodes.'),
    ]), sp(12),
]

# T06 Surge + ML
story += [section_header('T06', 'Surge Detection & Prediction'), sp(6),
    info_card('Surge detection pipeline',
              'Each platform adapter emits a SurgeEvent to Kafka when a fetched fare multiplier changes '
              'by more than 0.1x from the previous reading. The surge prediction service consumes these '
              'events, updates a rolling window, and re-scores the surge forecast for the next 30-minute '
              'window using the XGBoost model.'),
    sp(6),
    P('ML model specification', s_h3), sp(4),
    three_col_cards([
        ('Algorithm','XGBoost regression. Trained per city + platform pair. Retrained weekly on Redshift fare history.'),
        ('Features','Hour of day, day of week, local weather (OpenWeatherMap), local event calendar (Ticketmaster API), rolling 7-day surge average for that route cluster.'),
        ('Output','Surge multiplier forecast for t+5, t+15, t+30 minutes. Confidence interval. "Surge-free by X:XX" string surfaced in Watch alert and Dynamic Island.'),
    ]), sp(6),
    code_block([
        '# Surge prediction event published to Kafka topic: surge.predictions',
        '{',
        '  "city": "bengaluru",',
        '  "platform": "uber",',
        '  "current_multiplier": 1.8,',
        '  "forecast": [',
        '    { "minutes": 5,  "multiplier": 1.6, "confidence": 0.82 },',
        '    { "minutes": 15, "multiplier": 1.2, "confidence": 0.71 },',
        '    { "minutes": 30, "multiplier": 1.0, "confidence": 0.61 }',
        '  ],',
        '  "alert_trigger": "surge_free_at",',
        '  "alert_message": "Uber likely surge-free in ~30 min"',
        '}',
    ]), sp(12),
]

# T07 Push
story += [section_header('T07', 'Push Notification Architecture'), sp(6),
    two_col_cards([
        ('APNs delivery',
         'Node.js notification service uses @parse/node-apn library. Sends via APNs HTTP/2 API. '
         'Production cert + sandbox cert managed in AWS Secrets Manager. Retry with exponential backoff on 503.'),
        ('Notification types',
         'surge_alert (time-sensitive, interruption-level: time-sensitive), '
         'calendar_ride_reminder (active), spend_weekly_summary (passive), '
         'live_activity_update (pushToStartToken for Live Activities on iOS 17+).'),
        ('User preferences sync',
         'Notification preferences stored in profile service (DynamoDB). Synced to device via CloudKit. '
         'Focus mode state read from device at notification send time via device-side filter in NotificationServiceExtension.'),
        ('Rate limiting',
         'Max 3 surge alerts per user per hour. Max 1 calendar reminder per event. '
         'Weekly summary: single push every Monday 9am local time. All limits enforced server-side in Redis.'),
    ]), sp(12),
]

# T08 iOS client
story += [section_header('T08', 'iOS Client Architecture'), sp(6),
    three_col_cards([
        ('State management','SwiftUI + @Observable (iOS 17). Single AppStore actor for global state. Route-level ViewModels for local state. No third-party state library.'),
        ('Networking layer','URLSession async/await. Custom FareAPIClient with automatic retry (3 attempts, exponential backoff). Response decoded via Codable. URLCache for offline fallback.'),
        ('Core Data + CloudKit','User preferences, saved routes, spend history synced via NSPersistentCloudKitContainer. Auto-resolves merge conflicts with last-write-wins on non-critical fields.'),
        ('Core ML integration','CommutePredictor.mlpackage compiled into app bundle. Inference runs on Neural Engine. Model updated quarterly via Core ML on-device personalisation pipeline (no data leaves device).'),
        ('WidgetKit','3 widget families: systemSmall (cheapest fare), systemMedium (top-3 results), accessoryCircular (surge indicator for Lock Screen). All read from shared App Group Core Data store.'),
        ('Live Activities','ActivityKit pushToStartToken registered on first launch. FareTrackingAttributes struct shared with Notification Service Extension. Dynamic Island compact/expanded views in SwiftUI.'),
    ]), sp(12),
]

# T09 Security
story += [section_header('T09', 'Security & Privacy'), sp(6),
    two_col_cards([
        ('Auth & identity',
         'Sign in with Apple as the sole auth method. No passwords stored. JWT validated server-side against Apple public keys (JWKS endpoint, cached 1h). '
         'User ID is Apple\'s anonymised identifier — not linked to email without explicit consent.'),
        ('Location data handling',
         'Core Location access: "When In Use" permission only, never "Always". Location sent in API request body (TLS 1.3), not stored server-side. '
         'Aggregation service processes coordinates and immediately discards after route computation.'),
        ('Data minimisation',
         'No device fingerprinting. No advertising identifier (ATT not requested). Analytics events are anonymised at source (no user ID in event payload). '
         'Server logs auto-purged after 7 days. DPDP Act 2023 compliant.'),
        ('API security',
         'All endpoints behind AWS WAF + Shield Standard. Rate limiting: 100 fare searches/min per JWT. '
         'Certificate pinning in iOS client for /v1/* endpoints. API keys for platform adapters in AWS Secrets Manager with 30-day rotation.'),
    ]), sp(12),
]

# T10 Infra
story += [section_header('T10', 'Infrastructure & Deployment'), sp(6),
    dark_card('AWS production infrastructure', [
        ('Compute','ECS Fargate for all microservices. Auto-scaling on CPU >60% and p95 latency >800ms. Minimum 2 tasks per service across 2 AZs.'),
        ('Database','RDS PostgreSQL (Multi-AZ) for user profiles and subscription state. DynamoDB for notification preferences (single-table design). Redshift for analytics warehouse.'),
        ('Cache','ElastiCache Redis 7.x. Cluster mode enabled. Per-city shard to isolate eviction. Read replicas for fare-read traffic.'),
        ('Messaging','Amazon MSK (managed Kafka). 3 brokers, replication factor 3. Topics: fare.fetched, surge.events, surge.predictions, notifications.queued.'),
        ('CI/CD','GitHub Actions → ECR image build → ECS blue/green deployment via CodeDeploy. Automated rollback on CloudWatch alarm. Zero-downtime deploys.'),
        ('Observability','Datadog APM for distributed tracing. CloudWatch for infra metrics. PagerDuty for on-call alerts. SLO dashboard: p50/p95/p99 fare latency, adapter error rate per platform, cache hit rate.'),
        ('Disaster recovery','Multi-AZ by default. RTO target: 15 minutes. RPO: 1 hour (RDS automated snapshots every 1h). Annual DR drill required.'),
        ('Cost targets','Infra cost <8% of revenue at scale. Fargate Spot instances for non-critical batch jobs (GTFS ingestion, model retraining).'),
    ]),
    sp(12), PageBreak(),
]

# Final footer page
story += [
    sp(20),
    P('APPROVALS & SIGN-OFF', s_eyebrow), sp(8),
]
signoff_data = [
    ['Product Management', 'Full PRD reviewed and approved', '________', '________'],
    ['Engineering Lead', 'Technical spec reviewed and feasible', '________', '________'],
    ['Design Lead', 'UX requirements confirmed', '________', '________'],
    ['Legal / Privacy', 'DPDP + App Store compliance confirmed', '________', '________'],
    ['Security', 'Architecture security review passed', '________', '________'],
]
sh = [[P(h, s_label) for h in ['Role','Responsibility','Signature','Date']]]
sr2 = [[P(a, s_card_title), P(b, s_body), P(c, s_body), P(d, s_body)] for a,b,c,d in signoff_data]
st2 = Table(sh+sr2, colWidths=[120, 200, 80, 58])
st2.setStyle(TableStyle([
    ('BACKGROUND',(0,0),(-1,-1),CARD),
    ('BOX',(0,0),(-1,-1),0.5,BORDER),
    ('ROUNDEDCORNERS',[8]),
    ('LINEBELOW',(0,0),(-1,0),0.5,BORDER),
    ('TOPPADDING',(0,0),(-1,-1),10),('BOTTOMPADDING',(0,0),(-1,-1),10),
    ('LEFTPADDING',(0,0),(-1,-1),10),('RIGHTPADDING',(0,0),(-1,-1),10),
    ('VALIGN',(0,0),(-1,-1),'TOP'),
    *[('LINEBELOW',(0,i),(-1,i),0.5,BORDER) for i in range(1,len(sr2))],
]))
story += [st2, sp(20)]

footer_row = [[
    P('RideScout v2.0\nFull PRD + Technical Spec', S('fl', fontSize=9, textColor=INK2, leading=14)),
    P('Confidential\nDo Not Distribute', S('fc', fontSize=9, textColor=INK3, leading=14, alignment=TA_CENTER)),
    P('Next Review: May 16, 2026\nStatus: Draft — Pending Approval', S('fr', fontSize=9, textColor=INK2, leading=14, alignment=TA_RIGHT)),
]]
ft = Table(footer_row, colWidths=[153, 152, 153])
ft.setStyle(TableStyle([
    ('BACKGROUND',(0,0),(-1,-1),SURFACE),
    ('ROUNDEDCORNERS',[10]),
    ('TOPPADDING',(0,0),(-1,-1),12),('BOTTOMPADDING',(0,0),(-1,-1),12),
    ('LEFTPADDING',(0,0),(-1,-1),14),('RIGHTPADDING',(0,0),(-1,-1),14),
    ('VALIGN',(0,0),(-1,-1),'MIDDLE'),
]))
story.append(ft)

# ── Build PDF ─────────────────────────────────────────────────────────
out = './RideScout_PRD_TechSpec.pdf'
doc = SimpleDocTemplate(
    out, pagesize=A4,
    leftMargin=30*mm, rightMargin=20*mm,
    topMargin=22*mm, bottomMargin=18*mm,
    title='RideScout — Full PRD & Technical Specification',
    author='RideScout Product Team',
    subject='Full Product Requirements + Fare Aggregation Backend Spec',
)
doc.build(story, onFirstPage=on_page, onLaterPages=on_page)
print('Done:', out)
