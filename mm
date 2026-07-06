<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>생각하고 조작하는 통계 실험실 - 중3 수학 6단원 통계</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <!-- Firebase Legacy Compat SDK -->
    <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-app-compat.js"></script>
    <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-database-compat.js"></script>
    <!-- Google Fonts: Pretendard for premium Korean typography -->
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    
    <style>
        :root {
            --primary: #3B82F6;
            --primary-hover: #2563EB;
            --secondary: #1E293B;
            --bg: #F8FAFC;
            --card-bg: #FFFFFF;
            --text: #334155;
            --accent: #10B981;
            --accent-hover: #0D9488;
            --concept-bg: #F1F5F9;
            --padlet-color: #FF4081;
            --padlet-hover: #E91E63;
        }
        * { box-sizing: border-box; }
        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif;
            background-color: var(--bg);
            color: var(--text);
            margin: 0; padding: 0;
            line-height: 1.6;
            font-size: 1.05rem; /* Base font size increased slightly */
        }
        
        /* Global Tailwind font size scale-up */
        .text-xs { font-size: 0.85rem !important; }
        .text-sm { font-size: 0.98rem !important; }
        .text-base { font-size: 1.1rem !important; }
        .text-lg { font-size: 1.25rem !important; }
        .text-xl { font-size: 1.45rem !important; }
        .text-2xl { font-size: 1.7rem !important; }
        .text-3xl { font-size: 2.1rem !important; }

        input, select, textarea, button {
            font-size: 0.98rem !important;
        }
        
        /* Nav active border animation effect */
        .tab-btn {
            position: relative;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .tab-btn::after {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 50%;
            width: 0;
            height: 3px;
            background-color: var(--primary);
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }
        .tab-btn.active::after {
            width: 100%;
        }

        /* Chart Canvas layout rules to prevent stretching */
        .canvas-container {
            position: relative;
            width: 100%;
            height: 220px;
        }
        .canvas-container-small {
            position: relative;
            width: 100%;
            height: 150px;
        }
        .canvas-container-scatter {
            position: relative;
            width: 100%;
            height: 280px;
        }

        /* Concept Cards styling */
        .concept-card {
            background-color: #F8FAFC;
            border: 1px solid #E2E8F0;
            border-left: 5px solid var(--secondary);
            padding: 22px;
            border-radius: 12px;
            margin-bottom: 25px;
        }

        /* Table styling */
        table { width: 100%; border-collapse: collapse; margin-bottom: 15px; background: white; border-radius: 8px; overflow: hidden; }
        th, td { border: 1px solid #E2E8F0; padding: 10px; text-align: center; }
        th { background-color: #F1F5F9; font-weight: 700; color: #1E293B; }

        /* Interactive graphic booths */
        .market-booth { flex: 1; min-width: 280px; border: 3px solid #FCA5A5; border-radius: 12px; background: #FFF5F5; overflow: hidden; display: flex; flex-direction: column; justify-content: center; align-items: center; padding: 25px; text-align: center; position: relative; }
        .market-booth::before { content: "⛺"; font-size: 2.8rem; margin-bottom: 5px; }
        .event-poster { width: 280px; background: #FFF; border: 2px dashed #A78BFA; border-radius: 8px; padding: 18px; box-shadow: 5px 5px 0px #DDD6FE; transform: rotate(1deg); display: flex; flex-direction: column; align-items: center; }
        .poster-badge { background-color: #3B82F6; color: white; padding: 2px 10px; font-size: 0.8rem; font-weight: bold; border-radius: 4px; margin-bottom: 8px; }

        /* Custom Elegant Modal Overlay */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.4);
            backdrop-filter: blur(6px);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        /* Sub-tab styling for 대푯값 */
        .sub-tab-btn {
            transition: all 0.2s ease;
        }
    </style>
</head>
<body class="text-slate-800 antialiased min-h-screen flex flex-col">

    <!-- 1. Header Banner -->
    <header class="bg-gradient-to-r from-[#2563EB] via-[#4F46E5] to-[#7C3AED] text-white py-8 px-6 md:px-12 relative shadow-md">
        <div class="max-w-7xl mx-auto flex flex-col md:flex-row md:items-center justify-between gap-6">
            <!-- Brand & Mascot Logo -->
            <div class="flex items-center gap-4">
                <div class="bg-white/20 p-3 rounded-2xl backdrop-blur-md border border-white/20 shadow-inner">
                    <!-- Statistics Mascot SVG -->
                    <svg class="w-10 h-10 text-yellow-300 animate-bounce" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
                    </svg>
                </div>
                <div>
                    <h1 class="text-2xl md:text-3xl font-black tracking-tight drop-shadow-sm flex items-center gap-2">
                        생각하고 조작하는 통계 실험실 📊
                    </h1>
                    <p class="text-xs md:text-sm text-indigo-100 font-medium tracking-wide mt-1">
                        중학교 3학년 수학 | 6단원 통계 교과 연계
                    </p>
                </div>
            </div>

            <!-- Learning Objective Box -->
            <div class="bg-white/10 hover:bg-white/15 transition duration-200 border border-white/20 rounded-2xl p-4 max-w-sm backdrop-blur-sm">
                <span class="text-yellow-300 font-extrabold text-xs block mb-1">🎯 오늘의 배움 목표</span>
                <p class="text-xs md:text-[13px] leading-relaxed text-slate-100 font-medium">
                    대푯값과 산포도의 수학적 의미를 실험과 그래프 조작을 통해 깊이 이해하고, 생활 속 데이터를 분석해 상관관계를 판독할 수 있다.
                </p>
            </div>
        </div>
    </header>

    <!-- 2. Sticky Tab Navigation Bar -->
    <nav class="sticky top-0 bg-white border-b border-slate-200 shadow-sm z-50 flex justify-center overflow-x-auto whitespace-nowrap">
        <div class="max-w-7xl w-full flex justify-around md:justify-center md:gap-8 px-4">
            <button onclick="showSection('section1')" id="btn-section1" class="tab-btn active px-4 py-4 text-sm md:text-base font-bold text-slate-600 hover:text-blue-600 flex items-center gap-2">
                📖 1. 대푯값 실험실
            </button>
            <button onclick="showSection('section2')" id="btn-section2" class="tab-btn px-4 py-4 text-sm md:text-base font-bold text-slate-600 hover:text-blue-600 flex items-center gap-2">
                📉 2. 산포도 실험실
            </button>
            <button onclick="showSection('section3')" id="btn-section3" class="tab-btn px-4 py-4 text-sm md:text-base font-bold text-slate-600 hover:text-blue-600 flex items-center gap-2">
                📈 3. 상관관계 분석
            </button>
            <button onclick="showSection('section4')" id="btn-section4" class="tab-btn px-4 py-4 text-sm md:text-base font-bold text-slate-600 hover:text-blue-600 flex items-center gap-2">
                💬 4. 우리의 생각 나누기
            </button>
        </div>
    </nav>

    <!-- 3. Main View Area -->
    <main class="flex-grow max-w-7xl w-full mx-auto p-4 md:p-8">

        <!-- ==============================================
             SECTION 1: 대푯값 실험실
             ============================================== -->
        <section id="section1" class="section block space-y-8 animate-fade-in">
            <!-- Textbook Activity Section -->
            <div class="bg-amber-50/50 rounded-2xl border-2 border-amber-200 p-6 md:p-8 space-y-6">
                <div class="inline-flex items-center gap-2 bg-purple-700 text-white font-black text-sm px-4 py-2 rounded-full shadow-sm">
                    🏛️ 단원 활동 01
                </div>
                <h3 class="text-xl font-bold text-slate-900 leading-snug">
                    경품 행사 광고를 통해 자료를 잘 대표하는 통계 값을 탐구해 봅시다.
                </h3>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Booth Mockup -->
                    <div class="border-4 border-red-300 rounded-2xl bg-red-50/70 p-6 flex flex-col items-center justify-center text-center space-y-3 relative overflow-hidden">
                        <span class="text-xs text-red-500 font-extrabold uppercase tracking-widest">[어느 가게의 행사 부스]</span>
                        <div class="bg-white px-5 py-3 border-2 border-red-500 rounded-xl shadow-sm">
                            <span class="text-red-600 font-black text-sm md:text-base">구매자에게 백만 원짜리 경품권 증정!</span>
                        </div>
                    </div>

                    <!-- Event Poster -->
                    <div class="border-2 border-dashed border-indigo-300 rounded-2xl bg-white p-6 shadow-sm flex flex-col items-center justify-center space-y-4">
                        <div class="bg-indigo-600 text-white font-extrabold px-3 py-1 rounded-md text-xs">★ 개업 1주년 특별 이벤트 ★</div>
                        <p class="text-xs font-bold text-slate-500 text-center">선착순으로 당일 방문 구매자 100명에게 경품권을 지급해 드립니다.</p>
                        <div class="bg-slate-50 border border-slate-200 rounded-xl p-4 w-full text-center space-y-1">
                            <div class="text-indigo-600 font-extrabold text-sm">백만 원짜리 경품권 ➔ 1명</div>
                            <div class="text-slate-700 font-medium text-xs">만 원짜리 경품권 ➔ 10명</div>
                            <div class="text-slate-400 font-medium text-xs">천 원짜리 경품권 ➔ 89명</div>
                        </div>
                    </div>
                </div>

                <!-- Interactive Question Form -->
                <div class="bg-white rounded-xl p-5 border border-slate-200 shadow-sm space-y-4">
                    <h4 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                        <span class="w-6 h-6 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center text-xs font-bold">1</span>
                        이 경품권의 평균 금액과 가장 많이 발행된 경품권의 금액(최빈값)을 각각 계산하여 맞춰보세요.
                    </h4>
                    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4 items-center">
                        <input type="number" id="ad-q1-mean" placeholder="평균 금액 입력 (원)" class="w-full bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                        <input type="number" id="ad-q1-mode" placeholder="가장 흔한 금액 최빈값 (원)" class="w-full bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                        <button onclick="checkAdQ1Answer()" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2.5 px-4 rounded-lg text-sm transition shadow-sm">
                            정답 확인하기
                        </button>
                    </div>
                </div>

                <div class="bg-white rounded-xl p-5 border border-slate-200 shadow-sm space-y-4">
                    <h4 class="font-bold text-slate-800 text-sm flex items-center gap-2">
                        <span class="w-6 h-6 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center text-xs font-bold">2</span>
                        위 부스 광고는 실제 대푯값을 왜곡한 과장 광고일까요? 생각을 작성해 봅시다.
                    </h4>
                    <div class="space-y-3">
                        <select id="ad-q2-select" class="w-full bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                            <option value="">-- 광고의 타당성 판단 선택 --</option>
                            <option value="과장">과장 광고가 맞다 (극단적인 아주 큰 값(1명)으로 다수의 실질 혜택인 최빈값을 숨겼다)</option>
                            <option value="아님">과장 광고가 아니다 (실제로 단 1명이더라도 지급하는 것은 사실이기 때문에 무방하다)</option>
                        </select>
                        <input type="text" id="ad-q2-new-text" placeholder="수정한 정직한 광고 제안 문구 (예: 우리 매장은 평균 11,890원의 경품을 증정합니다!)" class="w-full bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                        <textarea id="ad-q2-reason-text" placeholder="그렇게 수정한 사유를 통계적 대푯값(평균 혹은 최빈값) 관점에서 증명하여 서술하세요." class="w-full bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-sm h-24 focus:ring-2 focus:ring-blue-500 outline-none resize-none"></textarea>
                    </div>
                    <button onclick="saveAdMissionToOpinion()" class="w-full bg-slate-700 hover:bg-slate-800 text-white font-bold py-3 px-4 rounded-lg text-sm transition flex items-center justify-center gap-2">
                        💾 위 답변을 대푯값 보고서 대기열로 복사하기
                    </button>
                </div>
            </div>

            <!-- Sub tabs for 1.대푯값 실험실 -->
            <div class="bg-white rounded-2xl border border-slate-200 p-6 shadow-sm space-y-6">
                <div class="border-b border-slate-200">
                    <h3 class="text-lg font-bold text-slate-900 pb-3 flex items-center gap-2">
                        📘 핵심 대푯값 개념 & 실시간 분석 실습
                    </h3>
                    <div class="flex gap-2 overflow-x-auto pb-3">
                        <button onclick="switchSubTab('sub1')" id="sub-btn-sub1" class="sub-tab-btn active px-4 py-2 text-xs md:text-sm font-bold rounded-xl transition duration-200 bg-blue-600 text-white">
                            1. 평균값 (Mean)
                        </button>
                        <button onclick="switchSubTab('sub2')" id="sub-btn-sub2" class="sub-tab-btn px-4 py-2 text-xs md:text-sm font-bold rounded-xl transition duration-200 bg-slate-100 text-slate-700 hover:bg-slate-200">
                            2. 중앙값 (Median)
                        </button>
                        <button onclick="switchSubTab('sub3')" id="sub-btn-sub3" class="sub-tab-btn px-4 py-2 text-xs md:text-sm font-bold rounded-xl transition duration-200 bg-slate-100 text-slate-700 hover:bg-slate-200">
                            3. 최빈값 (Mode)
                        </button>
                    </div>
                </div>

                <!-- Sub View 1: 평균 -->
                <div id="sub-view-sub1" class="sub-view block space-y-4">
                    <div class="bg-blue-50 border-l-4 border-blue-500 p-4 rounded-r-xl">
                        <h4 class="font-extrabold text-blue-800 text-sm">평균값 (Mean)</h4>
                        <p class="text-xs text-slate-600 mt-1 leading-relaxed">
                            모든 변량의 합을 총 개수로 나눈 값으로, 자료가 고르고 극단적인 수치가 없을 때 자료 전반의 중심적 경향을 가장 잘 보여주는 대표 지표입니다.
                        </p>
                    </div>
                    <!-- Calculator UI layout -->
                    <div class="bg-slate-900 rounded-2xl p-4 shadow-md space-y-3 max-w-sm mx-auto">
                        <div id="calc-screen" class="bg-slate-950 text-[#34D399] font-mono text-right text-2xl py-3 px-4 rounded-xl shadow-inner min-h-[50px] flex items-center justify-end">0</div>
                        <div class="grid grid-cols-4 gap-2">
                            <button onclick="pressCalcKey('7')" class="bg-slate-800 text-white py-2.5 font-bold rounded-lg hover:bg-slate-700 active:scale-95 transition text-sm">7</button>
                            <button onclick="pressCalcKey('8')" class="bg-slate-800 text-white py-2.5 font-bold rounded-lg hover:bg-slate-700 active:scale-95 transition text-sm">8</button>
                            <button onclick="pressCalcKey('9')" class="bg-slate-800 text-white py-2.5 font-bold rounded-lg hover:bg-slate-700 active:scale-95 transition text-sm">9</button>
                            <button onclick="pressCalcKey('C')" class="bg-red-600 text-white py-2.5 font-bold rounded-lg hover:bg-red-500 active:scale-95 transition text-sm">C</button>
                            
                            <button onclick="pressCalcKey('4')" class="bg-slate-800 text-white py-2.5 font-bold rounded-lg hover:bg-slate-700 active:scale-95 transition text-sm">4</button>
                            <button onclick="pressCalcKey('5')" class="bg-slate-800 text-white py-2.5 font-bold rounded-lg hover:bg-slate-700 active:scale-95 transition text-sm">5</button>
                            <button onclick="pressCalcKey('6')" class="bg-slate-800 text-white py-2.5 font-bold rounded-lg hover:bg-slate-700 active:scale-95 transition text-sm">6</button>
                            <button onclick="pressCalcKey('←')" class="bg-slate-700 text-slate-200 py-2.5 font-bold rounded-lg hover:bg-slate-600 active:scale-95 transition text-sm">←</button>
                            
                            <button onclick="pressCalcKey('1')" class="bg-slate-800 text-white py-2.5 font-bold rounded-lg hover:bg-slate-700 active:scale-95 transition text-sm">1</button>
                            <button onclick="pressCalcKey('2')" class="bg-slate-800 text-white py-2.5 font-bold rounded-lg hover:bg-slate-700 active:scale-95 transition text-sm">2</button>
                            <button onclick="pressCalcKey('3')" class="bg-slate-800 text-white py-2.5 font-bold rounded-lg hover:bg-slate-700 active:scale-95 transition text-sm">3</button>
                            <button onclick="pressCalcKey('.')" class="bg-slate-700 text-slate-200 py-2.5 font-bold rounded-lg hover:bg-slate-600 active:scale-95 transition text-sm">.</button>
                            
                            <button onclick="pressCalcKey('0')" class="col-span-2 bg-slate-800 text-white py-2.5 font-bold rounded-lg hover:bg-slate-700 active:scale-95 transition text-sm">0</button>
                            <button onclick="pressCalcKey('+/-')" class="bg-slate-700 text-slate-200 py-2.5 font-bold rounded-lg hover:bg-slate-600 active:scale-95 transition text-sm">+/-</button>
                            <button onclick="addCalcValueToList()" class="bg-blue-600 text-white py-2.5 font-bold rounded-lg hover:bg-blue-500 active:scale-95 transition text-xs">추가</button>
                        </div>
                        <button onclick="resetMeanCalc()" class="w-full bg-slate-800 text-slate-400 py-1.5 rounded-lg text-xs hover:text-white transition">리스트 지우기</button>
                    </div>
                    <div class="bg-slate-50 border border-slate-100 rounded-xl p-3 text-xs text-slate-600 space-y-2 max-w-sm mx-auto">
                        <div id="mean-calc-list" class="font-bold truncate">입력 값: (비어있음)</div>
                        <div id="mean-calc-result" class="text-blue-600 font-extrabold text-sm">평균이 여기에 산출됩니다.</div>
                    </div>
                </div>

                <!-- Sub View 2: 중앙값 -->
                <div id="sub-view-sub2" class="sub-view hidden space-y-4">
                    <div class="bg-purple-50 border-l-4 border-purple-500 p-4 rounded-r-xl">
                        <h4 class="font-extrabold text-purple-800 text-sm">중앙값 (Median)</h4>
                        <p class="text-xs text-slate-600 mt-1 leading-relaxed">
                            크기 순서대로 자료를 정렬했을 때 한가운데에 위치하는 수치입니다. 극단적인 특이값에 영향을 전혀 받지 않으므로, 이상치가 섞여 있을 때 최상의 대푯값 역할을 합니다.
                        </p>
                    </div>
                    <div class="space-y-3 max-w-sm mx-auto">
                        <label class="text-xs font-bold text-slate-600 block">숫자 입력 (쉼표로 구분):</label>
                        <input type="text" id="median-visual-input" value="12, 18, 5, 27, 14" class="w-full bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-sm focus:ring-2 focus:ring-purple-500 outline-none">
                        <button onclick="visualizeMedian()" class="w-full bg-purple-600 hover:bg-purple-700 text-white font-bold py-2 px-4 rounded-lg text-xs transition">
                            정렬 및 홀짝형 중앙값 찾기
                        </button>
                    </div>
                    <div id="median-step-by-step" class="bg-slate-50 border border-slate-100 rounded-xl p-3 text-xs text-slate-600 leading-relaxed max-w-sm mx-auto max-h-[180px] overflow-y-auto">
                        정렬 및 연산 추적기가 여기에 표시됩니다.
                    </div>
                </div>

                <!-- Sub View 3: 최빈값 -->
                <div id="sub-view-sub3" class="sub-view hidden space-y-4">
                    <div class="bg-pink-50 border-l-4 border-pink-500 p-4 rounded-r-xl">
                        <h4 class="font-extrabold text-pink-800 text-sm">최빈값 (Mode)</h4>
                        <p class="text-xs text-slate-600 mt-1 leading-relaxed">
                            가장 자주 등장하는 수치입니다. 브랜드 선호도, 크기 선호 분포 등 질적 데이터 분석과 사업 발주 결정에 매우 최적화된 대푯값입니다.
                        </p>
                    </div>
                    <div class="bg-pink-50/50 rounded-xl p-3 border border-pink-100 space-y-2 max-w-md mx-auto">
                        <span class="text-xs font-bold text-pink-700 block">🛒 신발 가게 재고 발주 미션</span>
                        <p class="text-[11px] leading-relaxed text-slate-600">
                            이번 주 판매된 운동화의 발사이즈는 <strong>[230, 240, 240, 240, 250, 250, 270, 280]</strong> 입니다. 
                            (평균: 250mm, 중앙값: 245mm, 최빈값: 240mm) 점주는 어느 신발을 집중해서 주문해야 할까요?
                        </p>
                    </div>
                    <div id="mode-quiz-feedback" class="bg-slate-50 p-3 rounded-xl border border-slate-200 text-xs text-slate-600 min-h-[50px] flex items-center max-w-md mx-auto">
                        아래 대푯값 중 정답이라고 판별되는 단추를 탭해 보세요.
                    </div>
                    <div class="grid grid-cols-3 gap-1.5 max-w-md mx-auto">
                        <button onclick="checkModeQuiz('평균')" class="bg-slate-800 text-white py-2 px-1 rounded-lg text-xs hover:bg-slate-700 transition">평균(250mm)</button>
                        <button onclick="checkModeQuiz('중앙')" class="bg-slate-800 text-white py-2 px-1 rounded-lg text-xs hover:bg-slate-700 transition">중앙(245mm)</button>
                        <button onclick="checkModeQuiz('최빈')" class="bg-pink-600 text-white py-2 px-1 rounded-lg text-xs hover:bg-pink-500 font-bold transition">최빈(240mm)</button>
                    </div>
                </div>
            </div>

            <!-- 우리 모둠만의 대푯값 실험실 -->
            <div class="bg-white rounded-2xl border border-slate-200 p-6 md:p-8 shadow-sm space-y-6">
                <div class="space-y-1">
                    <h3 class="text-lg font-bold text-slate-900">🔬 우리 모둠만의 대푯값 실험실</h3>
                    <p class="text-xs text-slate-500">실제 조사한 수치 데이터를 직접 넣어 다양한 대푯값(평균, 중앙, 최빈)의 변화 양상을 분석해 보세요.</p>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="text-xs font-bold text-slate-500 block mb-1">데이터 분류 설명</label>
                        <input type="text" id="data-desc-1" placeholder="예: 우리 모둠원들의 주간 독서량(시간)" class="w-full bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-xs outline-none">
                    </div>
                    <div>
                        <label class="text-xs font-bold text-slate-500 block mb-1">수치 데이터 입력 (쉼표로 구분)</label>
                        <div class="flex gap-2">
                            <input type="text" id="data-input-1" value="5, 6, 8, 8, 45" class="flex-grow bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-xs outline-none">
                            <button onclick="calculateRepresentative()" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold px-4 rounded-lg text-xs transition">분석하기</button>
                        </div>
                    </div>
                </div>
                <div class="bg-indigo-50/50 p-4 rounded-xl border border-indigo-100 flex flex-wrap gap-4 items-center justify-around text-xs font-extrabold">
                    <div>평균: <span id="out-mean" class="text-blue-600 text-sm font-black">14.4</span></div>
                    <div>중앙값: <span id="out-median" class="text-purple-600 text-sm font-black">8</span></div>
                    <div>최빈값: <span id="out-mode" class="text-pink-600 text-sm font-black">8</span></div>
                </div>

                <div class="bg-slate-50 border rounded-xl p-4 space-y-4">
                    <div class="text-xs font-extrabold text-slate-700">🎯 모둠 대푯값 의사결정</div>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div>
                            <label class="text-[11px] font-bold text-slate-500 block mb-1">가장 적절한 대푯값 선정</label>
                            <select id="representative-choice-1" onchange="calculateRepresentative()" class="w-full bg-white border border-slate-300 rounded-lg p-2 text-xs outline-none">
                                <option value="">-- 대푯값 결정 --</option>
                                <option value="평균값">평균값 (극단치 없이 전체적으로 분포가 대칭인 경우)</option>
                                <option value="중앙값">중앙값 (극단적인 특이값이나 이상치가 포함되어 평균 왜곡이 의심되는 경우)</option>
                                <option value="최빈값">최빈값 (가장 선호하거나 자주 반복되는 수치를 골라야 하는 경우)</option>
                            </select>
                        </div>
                        <div class="md:col-span-2">
                            <label class="text-[11px] font-bold text-slate-500 block mb-1">그 대푯값을 선택한 수학적 판단 근거</label>
                            <textarea id="representative-choice-reason-1" oninput="calculateRepresentative()" placeholder="다른 통계적 대푯값보다 해당 대푯값이 더 타당하다고 결정한 이유를 수치 분포 특성에 비추어 구체적으로 쓰세요." class="w-full h-16 bg-white border border-slate-300 rounded-lg p-2 text-xs outline-none resize-none"></textarea>
                        </div>
                    </div>
                </div>

                <!-- 최종 종합 탐구 문제 -->
                <div class="bg-purple-50/40 border border-purple-200 rounded-2xl p-5 md:p-6 space-y-4">
                    <h4 class="text-sm font-black text-purple-900 flex items-center gap-2">
                        <span>📝 최종 종합 탐구 문제</span>
                    </h4>
                    <p class="text-xs text-slate-600 leading-relaxed">
                        <strong>"평균값, 중앙값, 최빈값은 각각 어떤 자료의 특성을 가질 때 대푯값으로 채택하기 적합할까요? 탐구한 의견을 간략히 종합하여 정리해 봅시다."</strong>
                    </p>
                    <textarea id="final-synthesis-question" oninput="calculateRepresentative()" placeholder="예: 아주 크거나 작은 예외적인 값이 포함되어 있다면 중앙값이 평균의 왜곡을 방어하며, 선호 조사나 최다 주문 품목 파악 시에는 최빈값이 가장 우수한 대푯값으로 작용합니다." class="w-full h-24 bg-white border border-slate-300 rounded-xl p-3 text-xs outline-none focus:ring-2 focus:ring-purple-500 resize-none"></textarea>
                </div>
            </div>

            <!-- 나의 분석 의견 공유하기 -->
            <div class="bg-white rounded-2xl p-6 md:p-8 shadow-sm border border-slate-200 space-y-4">
                <h4 class="text-base font-bold text-slate-900">✍️ [대푯값] 나의 분석 의견 공유하기</h4>
                <div class="grid grid-cols-3 gap-2">
                    <select id="student-class-1" class="bg-slate-50 border rounded-lg p-2 text-xs outline-none">
                        <script>
                            for(let i=1; i<=14; i++) { document.write(`<option value="${i}반">3학년 ${i}반</option>`); }
                        </script>
                    </select>
                    <input type="number" id="student-number-1" placeholder="학번" class="bg-slate-50 border rounded-lg p-2 text-xs outline-none">
                    <input type="text" id="student-name-1" placeholder="이름" class="bg-slate-50 border rounded-lg p-2 text-xs outline-none">
                </div>
                <textarea id="student-opinion-1" placeholder="수렴된 의견 결과가 여기에 가공되어 나타납니다." class="w-full bg-slate-50 border rounded-xl p-3 text-xs h-28 focus:ring-1 focus:ring-indigo-500 outline-none resize-none"></textarea>
                <div class="grid grid-cols-2 gap-2">
                    <button onclick="submitOpinion(1)" class="bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-2.5 px-4 rounded-xl text-xs transition">임시 등록하기</button>
                    <button onclick="submitToPadlet(1)" class="bg-pink-600 hover:bg-pink-700 text-white font-bold py-2.5 px-4 rounded-xl text-xs transition">⛺ 복사하고 패들렛 쓰기</button>
                </div>
            </div>

            <!-- Gemini AI 수학진단센터 (대푯값) -->
            <div class="bg-gradient-to-br from-indigo-950 via-slate-900 to-black text-white rounded-3xl p-6 shadow-xl border border-indigo-500/30 space-y-4">
                <h4 class="text-base font-black text-indigo-200">✨ Gemini AI 수학 통계 피드백 센터 (대푯값)</h4>
                <p class="text-xs text-indigo-300">내 대푯값 분석 내용이 수학적 기준에 부합하는지 AI 선생님에게 실시간 표 기반 피드백을 받아보세요.</p>
                <div class="flex gap-2">
                    <button onclick="requestAIFeedback(1)" class="bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold py-3 px-4 rounded-xl transition">📝 내 분석 의견 자동 검토받기</button>
                    <input type="text" id="ai-custom-input-1" placeholder="대푯값에 대해 질문해 보세요." class="flex-grow bg-slate-950/70 border border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-100 outline-none">
                    <button onclick="sendCustomAIQuestion(1)" class="bg-indigo-500 hover:bg-indigo-600 text-white font-bold px-4 rounded-xl text-xs transition">질문</button>
                </div>
                <div id="ai-response-box-1" class="hidden bg-slate-950/80 border border-indigo-500/20 rounded-2xl p-4 text-xs max-h-[300px] overflow-y-auto">
                    <div id="ai-loading-1" class="hidden text-center text-indigo-300 font-bold py-2">대기 중...</div>
                    <div id="ai-text-content-1" class="text-slate-200 space-y-2"></div>
                </div>
            </div>

            <!-- 실시간 학급 우드보드 -->
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-slate-200 space-y-4">
                <div class="flex items-center justify-between border-b pb-2">
                    <h3 class="text-sm font-bold text-slate-900">🔍 실시간 학급 임시 보드 (대푯값)</h3>
                    <select id="filter-class-1" onchange="renderOpinions(1)" class="bg-slate-50 border rounded-lg p-1.5 text-xs">
                        <option value="전체">전체 학급 보기</option>
                        <script>
                            for(let i=1; i<=14; i++) { document.write(`<option value="${i}반">${i}반</option>`); }
                        </script>
                    </select>
                </div>
                <div id="realtime-opinion-list-1" class="space-y-4 max-h-[250px] overflow-y-auto">
                    <p class="text-center text-xs text-slate-400 py-6">의견을 불러오는 중입니다...</p>
                </div>
            </div>

            <!-- 실시간 패들렛 연동 보드 (Section 1 하단) -->
            <div class="card p-6 border-2 border-pink-400 bg-rose-50/40 rounded-3xl space-y-4">
                <div class="flex justify-between items-center flex-wrap gap-4">
                    <div>
                        <h3 class="text-pink-600 font-black text-base flex items-center gap-2">⛺ 실시간 학급 패들렛 (Padlet) 연동 게시판</h3>
                        <p class="text-xs text-rose-700">작성한 보고서를 복사한 후 우하단 플러스(+) 단추를 눌러 붙여넣기 해보세요.</p>
                    </div>
                    <div class="flex gap-2 items-center">
                        <input type="text" class="padlet-url-input bg-white border border-slate-300 rounded-lg p-2 text-xs w-48 outline-none">
                        <button class="bg-pink-600 hover:bg-pink-700 text-white font-bold py-2 px-4 rounded-xl text-xs transition" onclick="changePadletUrl(this)">주소 변경</button>
                    </div>
                </div>
                <div class="h-[450px] rounded-2xl overflow-hidden border border-pink-200 bg-white">
                    <iframe class="padlet-iframe w-full h-full border-0" allow="camera;microphone;geolocation"></iframe>
                </div>
            </div>
        </section>

        <!-- ==============================================
             SECTION 2: 산포도 실험실
             ============================================== -->
        <section id="section2" class="section hidden space-y-8 animate-fade-in">
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-slate-100 flex flex-col md:flex-row gap-6 items-center">
                <div class="bg-indigo-100 text-indigo-600 p-4 rounded-2xl">
                    <span class="text-3xl">⚖️</span>
                </div>
                <div class="space-y-2">
                    <h3 class="text-lg font-bold text-slate-900">산포도: 자료가 평균에서 흩어져 있는 정도</h3>
                    <p class="text-sm text-slate-600 leading-relaxed">
                        평균이 같더라도 자료들이 실제로 퍼져 있는 성향은 매우 다를 수 있습니다. 자료가 평균 주위에 밀집되면 산포도가 작아지고, 고르지 않고 넓게 퍼질수록 커집니다.
                    </p>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-3 pt-2 text-xs">
                        <div class="bg-slate-50 p-2.5 rounded-lg border border-slate-100">
                            <strong>1. 편차 (Deviation)</strong>
                            <p class="text-[11px] text-slate-500 mt-1">자료의 변량에서 평균을 뺀 값입니다. <br><span class="text-indigo-600 font-extrabold">(※ 편차의 합은 항상 0입니다.)</span></p>
                        </div>
                        <div class="bg-slate-50 p-2.5 rounded-lg border border-slate-100">
                            <strong>2. 분산 (Variance)</strong>
                            <p class="text-[11px] text-slate-500 mt-1">편차들이 음수와 양수로 상쇄되는 것을 막기 위해 편차를 제곱하여 구한 평균값입니다.</p>
                        </div>
                        <div class="bg-slate-50 p-2.5 rounded-lg border border-slate-100">
                            <strong>3. 표준편차 (Std Dev)</strong>
                            <p class="text-[11px] text-slate-500 mt-1">분산의 양의 제곱근(√분산)으로, 실제 자료 변량과 단위를 통일한 직관적인 값입니다.</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Two class score distributions comparison -->
            <div class="bg-slate-50 border border-slate-200 rounded-2xl p-6 md:p-8 space-y-6">
                <div class="inline-flex items-center gap-2 bg-indigo-600 text-white font-black text-sm px-4 py-2 rounded-full shadow-sm">
                    🏫 단원 활동 02
                </div>
                <h3 class="text-xl font-bold text-slate-900 leading-snug">
                    두 반 성적 분포 그래프 분석 (두 학급 모두 평균 성적은 <strong class="text-blue-600">80점</strong>으로 같습니다.)
                </h3>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- class A -->
                    <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-4 text-center">
                        <span class="bg-blue-50 text-blue-600 font-black px-4 py-1.5 rounded-full text-xs">A반: 평균 부근에 밀집된 조밀한 성향 (산포도가 작음)</span>
                        <div class="canvas-container">
                            <canvas id="chartA"></canvas>
                        </div>
                        <p id="statA" class="text-sm font-extrabold text-blue-600">분산: 8.00 | 표준편차: √8.00 ≒ 2.83점</p>
                        <button onclick="downloadChartImage('chartA', 'A반_성적분포')" class="text-xs bg-slate-100 text-slate-600 font-bold px-3 py-1.5 rounded-lg hover:bg-slate-200 transition">💾 A반 그래프 저장</button>
                    </div>

                    <!-- class B -->
                    <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-4 text-center">
                        <span class="bg-red-50 text-red-600 font-black px-4 py-1.5 rounded-full text-xs">B반: 평균에서 널리 퍼진 산포된 성향 (산포도가 큼)</span>
                        <div class="canvas-container">
                            <canvas id="chartB"></canvas>
                        </div>
                        <p id="statB" class="text-sm font-extrabold text-red-600">분산: 200.00 | 표준편차: √200.00 ≒ 14.14점</p>
                        <button onclick="downloadChartImage('chartB', 'B반_성적분포')" class="text-xs bg-slate-100 text-slate-600 font-bold px-3 py-1.5 rounded-lg hover:bg-slate-200 transition">💾 B반 그래프 저장</button>
                    </div>
                </div>
            </div>

            <!-- Archery target activity -->
            <div class="bg-purple-50/50 border border-purple-200 rounded-2xl p-6 md:p-8 space-y-6">
                <div class="inline-flex items-center gap-2 bg-purple-700 text-white font-black text-sm px-4 py-2 rounded-full shadow-sm">
                    🎯 양궁 사격 분석
                </div>
                <h3 class="text-xl font-bold text-slate-900 leading-snug">
                    세 선수가 과녁을 맞춘 14회 사격 점수 분포를 바탕으로 분산이 가장 작은 선수를 맞혀 보세요.
                </h3>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="bg-white p-4 rounded-xl border border-purple-100 text-center space-y-3">
                        <span class="text-xs font-bold text-pink-600">선수 A (기록 7~10점)</span>
                        <div class="canvas-container-small">
                            <canvas id="targetChartA"></canvas>
                        </div>
                        <button onclick="downloadChartImage('targetChartA', '선수A_과녁_분포')" class="text-[10px] bg-slate-100 text-slate-500 font-bold px-2 py-1 rounded">💾 저장</button>
                    </div>
                    <div class="bg-white p-4 rounded-xl border border-purple-100 text-center space-y-3">
                        <span class="text-xs font-bold text-green-600">선수 B (기록 8~10점 편향)</span>
                        <div class="canvas-container-small">
                            <canvas id="targetChartB"></canvas>
                        </div>
                        <button onclick="downloadChartImage('targetChartB', '선수B_과녁_분포')" class="text-[10px] bg-slate-100 text-slate-500 font-bold px-2 py-1 rounded">💾 저장</button>
                    </div>
                    <div class="bg-white p-4 rounded-xl border border-purple-100 text-center space-y-3">
                        <span class="text-xs font-bold text-blue-600">선수 C (기록 고루 분산)</span>
                        <div class="canvas-container-small">
                            <canvas id="targetChartC"></canvas>
                        </div>
                        <button onclick="downloadChartImage('targetChartC', '선수C_과녁_분포')" class="text-[10px] bg-slate-100 text-slate-500 font-bold px-2 py-1 rounded">💾 저장</button>
                    </div>
                </div>

                <div class="bg-white rounded-xl p-5 border border-slate-200 shadow-sm space-y-4">
                    <div class="text-sm font-bold text-slate-800">질문: 세 선수 중 득점의 분산이 가장 작은 학생을 추정하고 논거를 제시하세요.</div>
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 items-center">
                        <select id="activity2-student-select" class="md:col-span-1 bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-sm focus:ring-2 focus:ring-purple-500 outline-none">
                            <option value="">-- 선수 선택 --</option>
                            <option value="학생 A">선수 A</option>
                            <option value="학생 B">선수 B (평균 9점에 가장 가깝게 모여있음)</option>
                            <option value="학생 C">선수 C</option>
                        </select>
                        <input type="text" id="activity2-reason-text" placeholder="점수 분포가 평균선 주위에 밀집해 있을 때 분산의 수학적 계산 차이를 근거로 설명해 주세요." class="md:col-span-2 bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-sm focus:ring-2 focus:ring-purple-500 outline-none">
                        <button onclick="saveActivity2ToOpinion()" class="bg-purple-600 hover:bg-purple-700 text-white font-bold py-2.5 px-4 rounded-lg text-sm transition">
                            의견 전송 및 복사
                        </button>
                    </div>
                </div>
            </div>

            <!-- Fine dust comparison -->
            <div class="bg-green-50/50 border border-green-200 rounded-2xl p-6 md:p-8 space-y-6">
                <div class="inline-flex items-center gap-2 bg-green-600 text-white font-black text-sm px-4 py-2 rounded-full shadow-sm">
                    🌫️ 열린 대기환경 분석
                </div>
                <h3 class="text-xl font-bold text-slate-900 leading-snug">
                    부산(지역 A)과 서울(지역 B)의 월별 미세먼지(PM10) 오염도(㎍/㎥) 데이터를 분석해 봅시다.
                </h3>

                <div class="bg-white p-4 rounded-xl border border-slate-200 overflow-x-auto shadow-inner">
                    <table class="w-full text-center text-xs border-collapse min-w-[500px]">
                        <thead>
                            <tr class="bg-slate-100">
                                <th class="border p-2 font-bold">지역 명칭</th>
                                <th class="border p-2">1월</th><th class="border p-2">2월</th><th class="border p-2">3월</th>
                                <th class="border p-2">4월</th><th class="border p-2">5월</th><th class="border p-2">6월</th>
                                <th class="border p-2">7월</th><th class="border p-2">8월</th><th class="border p-2">9월</th>
                                <th class="border p-2">10월</th><th class="border p-2">11월</th><th class="border p-2">12월</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="border p-2 font-bold text-blue-600">지역 A (부산)</td>
                                <td class="border p-2">42</td><td class="border p-2">48</td><td class="border p-2">52</td>
                                <td class="border p-2">45</td><td class="border p-2">38</td><td class="border p-2">30</td>
                                <td class="border p-2">28</td><td class="border p-2">32</td><td class="border p-2">35</td>
                                <td class="border p-2">40</td><td class="border p-2">44</td><td class="border p-2">46</td>
                            </tr>
                            <tr>
                                <td class="border p-2 font-bold text-red-600">지역 B (서울)</td>
                                <td class="border p-2">55</td><td class="border p-2">62</td><td class="border p-2">68</td>
                                <td class="border p-2">50</td><td class="border p-2">42</td><td class="border p-2">35</td>
                                <td class="border p-2">25</td><td class="border p-2">28</td><td class="border p-2">38</td>
                                <td class="border p-2">48</td><td class="border p-2">52</td><td class="border p-2">58</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <div class="lg:col-span-2 bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex flex-col justify-between items-center space-y-4">
                        <div class="canvas-container">
                            <canvas id="dustChart"></canvas>
                        </div>
                        <button onclick="downloadChartImage('dustChart', '월별_미세먼지_오염도')" class="text-xs bg-slate-100 text-slate-500 font-bold px-3 py-1.5 rounded-lg hover:bg-slate-200 transition">💾 미세먼지 그래프 저장</button>
                    </div>

                    <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex flex-col justify-between space-y-4">
                        <div class="space-y-3">
                            <span class="text-xs font-bold text-green-700 block">⚡ 스마트 연산기 가동</span>
                            <p class="text-xs text-slate-500">아래 버튼을 터치하여 두 지역의 평균, 분산, 표준편차 편차 제곱 합을 구동해냅니다.</p>
                            <button onclick="calculateDustStatistics()" class="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-2.5 px-4 rounded-lg text-xs transition">
                                월별 미세먼지 오염도 산출하기
                            </button>
                        </div>

                        <div id="dust-stat-results" class="hidden text-xs space-y-2 bg-slate-50 border border-slate-200 rounded-xl p-3">
                            <div class="flex justify-between border-b pb-1">
                                <strong>지역 A 부산:</strong>
                                <span>평균 <span id="dust-a-mean" class="font-bold"></span> | 분산 <span id="dust-a-var" class="font-bold"></span> | 표준편차 <span id="dust-a-std" class="font-bold"></span></span>
                            </div>
                            <div class="flex justify-between">
                                <strong>지역 B 서울:</strong>
                                <span>평균 <span id="dust-b-mean" class="font-bold"></span> | 분산 <span id="dust-b-var" class="font-bold"></span> | 표준편차 <span id="dust-b-std" class="font-bold"></span></span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-xl p-5 border border-slate-200 shadow-sm space-y-4">
                    <div class="text-sm font-bold text-slate-800">분석 질문: 두 지역 중 월별 대기 오염도 수치 변화가 더 작고 균일한 지역은 어디이며 그 수학적 근거는 무엇일까요?</div>
                    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 items-center">
                        <select id="dust-answer-select" class="md:col-span-1 bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-sm focus:ring-2 focus:ring-green-500 outline-none">
                            <option value="">-- 오염 변화도 선택 --</option>
                            <option value="지역 A">지역 A (부산) (표준편차가 더 작아서 수치가 고름)</option>
                            <option value="지역 B">지역 B (서울)</option>
                        </select>
                        <input type="text" id="dust-answer-reason" placeholder="구한 표준편차(√분산) 값을 수학적으로 직접 대입하여 비교 설명하십시오." class="md:col-span-2 bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-sm focus:ring-2 focus:ring-green-500 outline-none">
                        <button onclick="saveDustActivityToOpinion()" class="bg-green-600 hover:bg-green-700 text-white font-bold py-2.5 px-4 rounded-lg text-sm transition">
                            답안 임시 저장 및 복사
                        </button>
                    </div>
                </div>
            </div>

            <!-- Custom Data Sandbox for Dispersion -->
            <div class="bg-white rounded-2xl border border-slate-200 p-6 md:p-8 shadow-sm space-y-6">
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <div class="space-y-1">
                        <h3 class="text-lg font-bold text-slate-900">🔬 나만의 데이터 입력 및 분포 산출 실험실</h3>
                        <p class="text-xs text-slate-500">조사한 데이터 수치 여러 개를 넣으면 실시간 편차 분포를 구성하고 분산과 표준편차를 찾아냅니다.</p>
                    </div>
                    <div class="flex gap-2">
                        <input type="text" id="data-desc-2" placeholder="조사 자료 명칭 (예: 등교 시간)" class="bg-slate-50 border border-slate-300 rounded-lg px-3 py-1.5 text-xs outline-none focus:ring-2 focus:ring-blue-500">
                        <input type="text" id="data-input-2" value="60, 70, 80, 90, 100" class="bg-slate-50 border border-slate-300 rounded-lg px-3 py-1.5 text-xs outline-none focus:ring-2 focus:ring-blue-500">
                        <button onclick="calculateDispersion()" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold px-4 py-2 rounded-lg text-xs transition">계산 실행</button>
                    </div>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 items-center">
                    <div class="lg:col-span-2 bg-slate-50 border rounded-2xl p-4 text-center">
                        <div class="canvas-container-small">
                            <canvas id="customDispersionChart"></canvas>
                        </div>
                        <button onclick="downloadChartImage('customDispersionChart', '나만의_산포도_위치')" class="text-[10px] bg-white border border-slate-200 text-slate-500 font-bold px-2 py-1.5 mt-2 rounded">💾 커스텀 산포도 위치 저장</button>
                    </div>

                    <div class="bg-amber-50/50 border border-amber-200 rounded-2xl p-5 space-y-3">
                        <span class="text-xs font-bold text-amber-800 block">📐 연산 결과 피드백</span>
                        <div class="space-y-2 text-xs text-slate-700">
                            <div>평균 점수: <strong id="dispersion-mean" class="text-blue-600 text-sm">80.0</strong></div>
                            <div>자료 분산: <strong id="dispersion-variance" class="text-purple-600 text-sm">200.00</strong></div>
                            <div>표준편차: <strong id="dispersion-stddev" class="text-pink-600 text-sm">√200 ≒ 14.14</strong></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 나의 분석 의견 공유하기 -->
            <div class="bg-white rounded-2xl p-6 md:p-8 shadow-sm border border-slate-200 space-y-4">
                <h4 class="text-base font-bold text-slate-900">✍️ [산포도] 나의 분석 의견 공유하기</h4>
                <div class="grid grid-cols-3 gap-2">
                    <select id="student-class-2" class="bg-slate-50 border rounded-lg p-2 text-xs outline-none">
                        <script>
                            for(let i=1; i<=14; i++) { document.write(`<option value="${i}반">3학년 ${i}반</option>`); }
                        </script>
                    </select>
                    <input type="number" id="student-number-2" placeholder="학번" class="bg-slate-50 border rounded-lg p-2 text-xs outline-none">
                    <input type="text" id="student-name-2" placeholder="이름" class="bg-slate-50 border rounded-lg p-2 text-xs outline-none">
                </div>
                <textarea id="student-opinion-2" placeholder="수렴된 의견 결과가 여기에 가공되어 나타납니다." class="w-full bg-slate-50 border rounded-xl p-3 text-xs h-28 focus:ring-1 focus:ring-indigo-500 outline-none resize-none"></textarea>
                <div class="grid grid-cols-2 gap-2">
                    <button onclick="submitOpinion(2)" class="bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-2.5 px-4 rounded-xl text-xs transition">임시 등록하기</button>
                    <button onclick="submitToPadlet(2)" class="bg-pink-600 hover:bg-pink-700 text-white font-bold py-2.5 px-4 rounded-xl text-xs transition">⛺ 복사하고 패들렛 쓰기</button>
                </div>
            </div>

            <!-- Gemini AI 수학진단센터 (산포도) -->
            <div class="bg-gradient-to-br from-indigo-950 via-slate-900 to-black text-white rounded-3xl p-6 shadow-xl border border-indigo-500/30 space-y-4">
                <h4 class="text-base font-black text-indigo-200">✨ Gemini AI 수학 통계 피드백 센터 (산포도)</h4>
                <p class="text-xs text-indigo-300">내 산포도 분석 내용이 수학적 기준에 부합하는지 AI 선생님에게 실시간 표 기반 피드백을 받아보세요.</p>
                <div class="flex gap-2">
                    <button onclick="requestAIFeedback(2)" class="bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold py-3 px-4 rounded-xl transition">📝 내 분석 의견 자동 검토받기</button>
                    <input type="text" id="ai-custom-input-2" placeholder="산포도나 분산에 대해 질문해 보세요." class="flex-grow bg-slate-950/70 border border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-100 outline-none">
                    <button onclick="sendCustomAIQuestion(2)" class="bg-indigo-500 hover:bg-indigo-600 text-white font-bold px-4 rounded-xl text-xs transition">질문</button>
                </div>
                <div id="ai-response-box-2" class="hidden bg-slate-950/80 border border-indigo-500/20 rounded-2xl p-4 text-xs max-h-[300px] overflow-y-auto">
                    <div id="ai-loading-2" class="hidden text-center text-indigo-300 font-bold py-2">대기 중...</div>
                    <div id="ai-text-content-2" class="text-slate-200 space-y-2"></div>
                </div>
            </div>

            <!-- 실시간 학급 우드보드 -->
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-slate-200 space-y-4">
                <div class="flex items-center justify-between border-b pb-2">
                    <h3 class="text-sm font-bold text-slate-900">🔍 실시간 학급 임시 보드 (산포도)</h3>
                    <select id="filter-class-2" onchange="renderOpinions(2)" class="bg-slate-50 border rounded-lg p-1.5 text-xs">
                        <option value="전체">전체 학급 보기</option>
                        <script>
                            for(let i=1; i<=14; i++) { document.write(`<option value="${i}반">${i}반</option>`); }
                        </script>
                    </select>
                </div>
                <div id="realtime-opinion-list-2" class="space-y-4 max-h-[250px] overflow-y-auto">
                    <p class="text-center text-xs text-slate-400 py-6">의견을 불러오는 중입니다...</p>
                </div>
            </div>

            <!-- 실시간 패들렛 연동 보드 (Section 2 하단) -->
            <div class="card p-6 border-2 border-pink-400 bg-rose-50/40 rounded-3xl space-y-4">
                <div class="flex justify-between items-center flex-wrap gap-4">
                    <div>
                        <h3 class="text-pink-600 font-black text-base flex items-center gap-2">⛺ 실시간 학급 패들렛 (Padlet) 연동 게시판</h3>
                        <p class="text-xs text-rose-700">작성한 보고서를 복사한 후 우하단 플러스(+) 단추를 눌러 붙여넣기 해보세요.</p>
                    </div>
                    <div class="flex gap-2 items-center">
                        <input type="text" class="padlet-url-input bg-white border border-slate-300 rounded-lg p-2 text-xs w-48 outline-none">
                        <button class="bg-pink-600 hover:bg-pink-700 text-white font-bold py-2 px-4 rounded-xl text-xs transition" onclick="changePadletUrl(this)">주소 변경</button>
                    </div>
                </div>
                <div class="h-[450px] rounded-2xl overflow-hidden border border-pink-200 bg-white">
                    <iframe class="padlet-iframe w-full h-full border-0" allow="camera;microphone;geolocation"></iframe>
                </div>
            </div>
        </section>

        <!-- ==============================================
             SECTION 3: 상관관계 분석
             ============================================== -->
        <section id="section3" class="section hidden space-y-8 animate-fade-in">
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-slate-100 flex flex-col md:flex-row gap-6 items-center">
                <div class="bg-amber-100 text-amber-600 p-4 rounded-2xl">
                    <span class="text-3xl">🧩</span>
                </div>
                <div class="space-y-1">
                    <h3 class="text-lg font-bold text-slate-900">상관관계와 산점도 (Scatter Plot)</h3>
                    <p class="text-sm text-slate-600 leading-relaxed">
                        두 변량의 순서쌍을 평면에 점으로 나타낸 그래프를 <strong>산점도</strong>라고 부릅니다. 
                        X가 커질 때 Y가 대체로 커지면 <strong>양의 상관관계</strong>, 반대면 <strong>음의 상관관계</strong>, 아무런 경향이 없으면 <strong>상관관계가 없다</strong>고 판단합니다.
                    </p>
                </div>
            </div>

            <!-- Conceptual Cards with 예시 그래프(SVG) 탑재 -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- 양의 상관관계 -->
                <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm space-y-3 flex flex-col justify-between">
                    <div>
                        <h4 class="font-extrabold text-blue-600 text-sm">📈 양의 상관관계</h4>
                        <p class="text-[11px] text-slate-500 mt-1">X가 커질수록 Y도 대체로 증가합니다. 점들이 우상향 직선 모양으로 모입니다.</p>
                        <span class="inline-block bg-blue-50 text-blue-700 font-extrabold text-[10px] px-2 py-0.5 rounded mt-2">예: 키 vs 발 크기, 공부 시간 vs 성적</span>
                    </div>
                    <div class="h-32 bg-slate-50 rounded-xl border border-dashed border-slate-200 flex items-center justify-center p-2">
                        <svg class="w-full h-full" viewBox="0 0 100 100">
                            <line x1="10" y1="90" x2="90" y2="90" stroke="#CBD5E1" stroke-width="2"/>
                            <line x1="10" y1="10" x2="10" y2="90" stroke="#CBD5E1" stroke-width="2"/>
                            <circle cx="20" cy="80" r="3" fill="#3B82F6"/>
                            <circle cx="30" cy="72" r="3" fill="#3B82F6"/>
                            <circle cx="40" cy="65" r="3" fill="#3B82F6"/>
                            <circle cx="45" cy="55" r="3" fill="#3B82F6"/>
                            <circle cx="55" cy="45" r="3" fill="#3B82F6"/>
                            <circle cx="65" cy="38" r="3" fill="#3B82F6"/>
                            <circle cx="70" cy="25" r="3" fill="#3B82F6"/>
                            <circle cx="85" cy="15" r="3" fill="#3B82F6"/>
                            <line x1="15" y1="85" x2="85" y2="15" stroke="#3B82F6" stroke-width="1.5" stroke-dasharray="3,3" opacity="0.6"/>
                        </svg>
                    </div>
                </div>

                <!-- 음의 상관관계 -->
                <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm space-y-3 flex flex-col justify-between">
                    <div>
                        <h4 class="font-extrabold text-red-600 text-sm">📉 음의 상관관계</h4>
                        <p class="text-[11px] text-slate-500 mt-1">X가 커질수록 Y는 대체로 감소합니다. 점들이 우하향 직선 모양으로 모입니다.</p>
                        <span class="inline-block bg-red-50 text-red-700 font-extrabold text-[10px] px-2 py-0.5 rounded mt-2">예: 고도 vs 기온, 평균 운량 vs 일조 시간</span>
                    </div>
                    <div class="h-32 bg-slate-50 rounded-xl border border-dashed border-slate-200 flex items-center justify-center p-2">
                        <svg class="w-full h-full" viewBox="0 0 100 100">
                            <line x1="10" y1="90" x2="90" y2="90" stroke="#CBD5E1" stroke-width="2"/>
                            <line x1="10" y1="10" x2="10" y2="90" stroke="#CBD5E1" stroke-width="2"/>
                            <circle cx="20" cy="20" r="3" fill="#EF4444"/>
                            <circle cx="30" cy="35" r="3" fill="#EF4444"/>
                            <circle cx="42" cy="40" r="3" fill="#EF4444"/>
                            <circle cx="50" cy="55" r="3" fill="#EF4444"/>
                            <circle cx="60" cy="62" r="3" fill="#EF4444"/>
                            <circle cx="68" cy="70" r="3" fill="#EF4444"/>
                            <circle cx="78" cy="82" r="3" fill="#EF4444"/>
                            <line x1="15" y1="15" x2="85" y2="85" stroke="#EF4444" stroke-width="1.5" stroke-dasharray="3,3" opacity="0.6"/>
                        </svg>
                    </div>
                </div>

                <!-- 상관관계 없음 -->
                <div class="bg-white rounded-2xl border border-slate-200 p-5 shadow-sm space-y-3 flex flex-col justify-between">
                    <div>
                        <h4 class="font-extrabold text-slate-600 text-sm">⚪ 상관관계가 없음</h4>
                        <p class="text-[11px] text-slate-500 mt-1">X의 변화가 Y와 뚜렷한 관련성을 보이지 않고 무작위로 흩어져 있습니다.</p>
                        <span class="inline-block bg-slate-50 text-slate-700 font-extrabold text-[10px] px-2 py-0.5 rounded mt-2">예: 발 크기 vs 수학 점수, 시력 vs 몸무게</span>
                    </div>
                    <div class="h-32 bg-slate-50 rounded-xl border border-dashed border-slate-200 flex items-center justify-center p-2">
                        <svg class="w-full h-full" viewBox="0 0 100 100">
                            <line x1="10" y1="90" x2="90" y2="90" stroke="#CBD5E1" stroke-width="2"/>
                            <line x1="10" y1="10" x2="10" y2="90" stroke="#CBD5E1" stroke-width="2"/>
                            <circle cx="30" cy="30" r="3" fill="#64748B"/>
                            <circle cx="60" cy="20" r="3" fill="#64748B"/>
                            <circle cx="20" cy="50" r="3" fill="#64748B"/>
                            <circle cx="45" cy="45" r="3" fill="#64748B"/>
                            <circle cx="70" cy="50" r="3" fill="#64748B"/>
                            <circle cx="35" cy="75" r="3" fill="#64748B"/>
                            <circle cx="65" cy="70" r="3" fill="#64748B"/>
                            <circle cx="50" cy="80" r="3" fill="#64748B"/>
                        </svg>
                    </div>
                </div>
            </div>

            <!-- Conceptual Check: Correlation vs Causality -->
            <div class="bg-rose-50/70 rounded-2xl border-2 border-rose-200 p-6 md:p-8 space-y-4">
                <h3 class="text-xl font-bold text-rose-800 leading-snug flex items-center gap-2">
                    ⚠️ [중요 통계 오류 파괴] 상관관계와 인과관계는 같지 않습니다!
                </h3>
                <p class="text-xs md:text-sm text-slate-700 leading-relaxed">
                    예를 들어, "아이스크림 소매 판매 금액"과 "바다 조난 사고 건수"의 산점도를 그리면 매우 강한 <strong>양의 상관관계</strong>를 띱니다. 
                    그렇다면 아이스크림을 팔지 못하게 금지하면 익사 사고가 사라질까요? 아닙니다! 두 현상 모두 <strong>"여름철 더위"</strong>라는 보이지 않는 제3의 외부 요인이 원인이 되어 
                    동시에 증가한 것 뿐입니다. 이렇듯 데이터의 추세를 통해 연관성(상관)을 판정하더라도, 직접적인 논리 인과로 함부로 규정하면 잘못된 통계 리터러시에 귀착됩니다.
                </p>
            </div>

            <!-- Communication Quiz -->
            <div class="bg-slate-50 border border-slate-200 rounded-2xl p-6 md:p-8 space-y-6">
                <div class="inline-flex items-center gap-2 bg-slate-600 text-white font-black text-sm px-4 py-2 rounded-full shadow-sm">
                    💬 교과서 의사소통 탐구
                </div>
                <h3 class="text-xl font-bold text-slate-900 leading-snug">
                    포물선(돔 모양)과 같이 데이터가 커졌다가 줄어드는 양상을 가질 때 두 변량 사이에 상관관계가 존재한다고 말할 수 있을까요?
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <button onclick="checkMathCommunication('준우')" class="bg-white hover:bg-slate-100 border border-slate-300 p-4 rounded-xl text-left text-xs font-bold leading-relaxed shadow-sm transition">
                        🙅‍♂️ 준우: "일단 절반은 상승하고 절반은 하락하는 방향을 보이고 있으므로 전체적으로 어떤 상관이 있겠지."
                    </button>
                    <button onclick="checkMathCommunication('하은')" class="bg-white hover:bg-slate-100 border border-slate-300 p-4 rounded-xl text-left text-xs font-bold leading-relaxed shadow-sm transition">
                        🙆‍♀️ 하은: "전체 구역에서 단방향으로 계속 증가하거나 감소하는 일정 양상이 없으므로 상관관계가 존재하지 않아."
                    </button>
                </div>
                <div id="math-comm-feedback" class="hidden p-4 rounded-xl border font-bold text-xs"></div>
            </div>

            <!-- Interactive Scatter Sandbox (Sunshine & Clouds) -->
            <div class="bg-amber-50/50 border border-amber-200 rounded-2xl p-6 md:p-8 space-y-6">
                <div class="inline-flex items-center gap-2 bg-amber-600 text-white font-black text-sm px-4 py-2 rounded-full shadow-sm">
                    ☁️ 기상 조건 산점도 분석
                </div>
                <h3 class="text-xl font-bold text-slate-900 leading-snug">
                    11월 한 달 중 관찰한 일조 시간(X축)과 평균 운량(Y축) 데이터 세트 분포를 조작해 분석합시다.
                </h3>

                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <div class="lg:col-span-2 bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex flex-col justify-between items-center space-y-4">
                        <div class="canvas-container-scatter">
                            <canvas id="weatherChart"></canvas>
                        </div>
                        <button onclick="downloadChartImage('weatherChart', '일조_운량_산점도')" class="text-xs bg-slate-100 text-slate-500 font-bold px-3 py-1.5 rounded-lg hover:bg-slate-200 transition">💾 기상 산점도 이미지 저장</button>
                    </div>

                    <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-4">
                        <span class="text-xs font-bold text-amber-700 block">❓ 퀴즈: 그래프 경향 판독</span>
                        <div class="space-y-3">
                            <select id="weather-answer-select" class="w-full bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-xs focus:ring-2 focus:ring-amber-500 outline-none">
                                <option value="">-- 판단한 상관관계 종류 --</option>
                                <option value="음">음의 상관관계 (해가 길어지면 평균 구름량이 준다)</option>
                                <option value="양">양의 상관관계</option>
                                <option value="없음">상관관계 없음</option>
                            </select>
                            <textarea id="weather-answer-reason" placeholder="기상 관측 상식 및 도표의 기울기를 엮어서 판단 사유를 직접 간략히 쓰세요." class="w-full bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-xs h-24 focus:ring-2 focus:ring-amber-500 outline-none resize-none"></textarea>
                            <button onclick="saveWeatherActivityToOpinion()" class="w-full bg-amber-600 hover:bg-amber-700 text-white font-bold py-2.5 px-4 rounded-lg text-xs transition">
                                분석 소견 전송 및 저장
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Dynamic Live Table Input for Custom Scatter -->
            <div class="bg-white rounded-2xl border border-slate-200 p-6 md:p-8 shadow-sm space-y-6">
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <div class="space-y-1">
                        <h3 class="text-lg font-bold text-slate-900">🔬 우리 모둠의 실험실</h3>
                        <p class="text-xs text-slate-500">학생들의 X변량과 Y변량을 임의로 편집하거나 학생을 추가하여 산점도를 실시간으로 관찰해 보세요.</p>
                    </div>
                    <div class="flex gap-2">
                        <button onclick="loadScenario('negative')" class="bg-slate-800 hover:bg-slate-700 text-white text-xs font-bold px-3 py-1.5 rounded-lg transition">📉 시나리오1: 게임 시간 vs 성적</button>
                        <button onclick="loadScenario('none')" class="bg-slate-800 hover:bg-slate-700 text-white text-xs font-bold px-3 py-1.5 rounded-lg transition">⚪ 시나리오2: 발 크기 vs 성적</button>
                    </div>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    <div class="bg-slate-50 rounded-2xl p-4 border overflow-y-auto max-h-[340px]">
                        <table id="scatter-table" class="w-full text-xs text-center">
                            <thead>
                                <tr class="bg-slate-200">
                                    <th class="p-2 border">학생 번호</th>
                                    <th id="th-x" class="p-2 border">X축 수치</th>
                                    <th id="th-y" class="p-2 border">Y축 수치</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Dynamic rows -->
                            </tbody>
                        </table>
                        <div class="mt-4 flex gap-2">
                            <button onclick="addTableRow()" class="flex-grow bg-slate-700 text-white py-2 rounded font-bold text-xs hover:bg-slate-600 transition">➕ 학생 행 추가</button>
                            <button onclick="updateScatterChart()" class="flex-grow bg-blue-600 text-white py-2 rounded font-bold text-xs hover:bg-blue-500 transition">📊 그래프에 반영하기</button>
                        </div>
                    </div>

                    <div class="bg-white p-4 rounded-2xl border text-center">
                        <div class="canvas-container-scatter">
                            <canvas id="scatterChart"></canvas>
                        </div>
                        <button onclick="downloadChartImage('scatterChart', '가상_시추_산점도')" class="text-[10px] bg-slate-100 text-slate-500 font-bold px-2 py-1.5 mt-2 rounded">💾 가상 산점도 저장</button>
                    </div>

                    <div class="bg-slate-50 rounded-2xl p-4 border flex flex-col justify-between">
                        <div class="space-y-3">
                            <span class="text-xs font-bold text-indigo-700 block">📊 그래프 해석 자가 검증</span>
                            <select id="user-correlation-answer" class="w-full bg-white border border-slate-300 rounded-lg p-2.5 text-xs outline-none">
                                <option value="">-- 상관관계 판단 --</option>
                                <option value="양">양의 상관관계</option>
                                <option value="음">음의 상관관계</option>
                                <option value="없음">상관관계 없음</option>
                            </select>
                            <button onclick="checkCorrelationAnswer()" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2 px-4 rounded-lg text-xs transition">
                                판단 검증하기
                            </button>
                        </div>
                        <button onclick="saveScatterExperimentToOpinion()" class="w-full bg-slate-800 hover:bg-slate-950 text-white font-bold py-3 rounded-lg text-xs transition mt-4">
                            ✍️ 이 시뮬레이션 결과를 종합 보고서에 전송하기
                        </button>
                    </div>
                </div>
            </div>

            <!-- 나의 분석 의견 공유하기 -->
            <div class="bg-white rounded-2xl p-6 md:p-8 shadow-sm border border-slate-200 space-y-4">
                <h4 class="text-base font-bold text-slate-900">✍️ [상관관계] 나의 분석 의견 공유하기</h4>
                <div class="grid grid-cols-3 gap-2">
                    <select id="student-class-3" class="bg-slate-50 border rounded-lg p-2 text-xs outline-none">
                        <script>
                            for(let i=1; i<=14; i++) { document.write(`<option value="${i}반">3학년 ${i}반</option>`); }
                        </script>
                    </select>
                    <input type="number" id="student-number-3" placeholder="학번" class="bg-slate-50 border rounded-lg p-2 text-xs outline-none">
                    <input type="text" id="student-name-3" placeholder="이름" class="bg-slate-50 border rounded-lg p-2 text-xs outline-none">
                </div>
                <textarea id="student-opinion-3" placeholder="수렴된 의견 결과가 여기에 가공되어 나타납니다." class="w-full bg-slate-50 border rounded-xl p-3 text-xs h-28 focus:ring-1 focus:ring-indigo-500 outline-none resize-none"></textarea>
                <div class="grid grid-cols-2 gap-2">
                    <button onclick="submitOpinion(3)" class="bg-emerald-600 hover:bg-emerald-700 text-white font-bold py-2.5 px-4 rounded-xl text-xs transition">임시 등록하기</button>
                    <button onclick="submitToPadlet(3)" class="bg-pink-600 hover:bg-pink-700 text-white font-bold py-2.5 px-4 rounded-xl text-xs transition">⛺ 복사하고 패들렛 쓰기</button>
                </div>
            </div>

            <!-- Gemini AI 수학진단센터 (상관관계) -->
            <div class="bg-gradient-to-br from-indigo-950 via-slate-900 to-black text-white rounded-3xl p-6 shadow-xl border border-indigo-500/30 space-y-4">
                <h4 class="text-base font-black text-indigo-200">✨ Gemini AI 수학 통계 피드백 센터 (상관관계)</h4>
                <p class="text-xs text-indigo-300">내 상관관계 분석 내용이 수학적 기준에 부합하는지 AI 선생님에게 실시간 표 기반 피드백을 받아보세요.</p>
                <div class="flex gap-2">
                    <button onclick="requestAIFeedback(3)" class="bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold py-3 px-4 rounded-xl transition">📝 내 분석 의견 자동 검토받기</button>
                    <input type="text" id="ai-custom-input-3" placeholder="상관관계나 인과관계에 대해 질문해 보세요." class="flex-grow bg-slate-950/70 border border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-100 outline-none">
                    <button onclick="sendCustomAIQuestion(3)" class="bg-indigo-500 hover:bg-indigo-600 text-white font-bold px-4 rounded-xl text-xs transition">질문</button>
                </div>
                <div id="ai-response-box-3" class="hidden bg-slate-950/80 border border-indigo-500/20 rounded-2xl p-4 text-xs max-h-[300px] overflow-y-auto">
                    <div id="ai-loading-3" class="hidden text-center text-indigo-300 font-bold py-2">대기 중...</div>
                    <div id="ai-text-content-3" class="text-slate-200 space-y-2"></div>
                </div>
            </div>

            <!-- 실시간 학급 우드보드 -->
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-slate-200 space-y-4">
                <div class="flex items-center justify-between border-b pb-2">
                    <h3 class="text-sm font-bold text-slate-900">🔍 실시간 학급 임시 보드 (상관관계)</h3>
                    <select id="filter-class-3" onchange="renderOpinions(3)" class="bg-slate-50 border rounded-lg p-1.5 text-xs">
                        <option value="전체">전체 학급 보기</option>
                        <script>
                            for(let i=1; i<=14; i++) { document.write(`<option value="${i}반">${i}반</option>`); }
                        </script>
                    </select>
                </div>
                <div id="realtime-opinion-list-3" class="space-y-4 max-h-[250px] overflow-y-auto">
                    <p class="text-center text-xs text-slate-400 py-6">의견을 불러오는 중입니다...</p>
                </div>
            </div>

            <!-- 실시간 패들렛 연동 보드 (Section 3 하단) -->
            <div class="card p-6 border-2 border-pink-400 bg-rose-50/40 rounded-3xl space-y-4">
                <div class="flex justify-between items-center flex-wrap gap-4">
                    <div>
                        <h3 class="text-pink-600 font-black text-base flex items-center gap-2">⛺ 실시간 학급 패들렛 (Padlet) 연동 게시판</h3>
                        <p class="text-xs text-rose-700">작성한 보고서를 복사한 후 우하단 플러스(+) 단추를 눌러 붙여넣기 해보세요.</p>
                    </div>
                    <div class="flex gap-2 items-center">
                        <input type="text" class="padlet-url-input bg-white border border-slate-300 rounded-lg p-2 text-xs w-48 outline-none">
                        <button class="bg-pink-600 hover:bg-pink-700 text-white font-bold py-2 px-4 rounded-xl text-xs transition" onclick="changePadletUrl(this)">주소 변경</button>
                    </div>
                </div>
                <div class="h-[450px] rounded-2xl overflow-hidden border border-pink-200 bg-white">
                    <iframe class="padlet-iframe w-full h-full border-0" allow="camera;microphone;geolocation"></iframe>
                </div>
            </div>
        </section>

        <!-- ==============================================
             SECTION 4: 우리의 생각 나누기
             ============================================== -->
        <section id="section4" class="section hidden space-y-8 animate-fade-in">
            <div class="bg-white rounded-2xl p-6 md:p-8 shadow-sm border border-slate-200 space-y-6">
                <div class="flex items-center gap-3 bg-indigo-50 text-indigo-700 p-4 rounded-2xl border border-indigo-100">
                    <span class="text-2xl">📢</span>
                    <div class="text-xs md:text-sm leading-relaxed">
                        <strong>통계 실험실 최종 종합 보고서 제출 안내</strong><br>
                        "대푯값 왜곡 사례, 표준편차가 가지는 의미, 그리고 상관관계와 인과관계의 차이를 모둠 의견에 녹여 공유 보드에 등록하고 패들렛에 백업하십시오."
                    </div>
                </div>
            </div>

            <!-- Consolidated Report Writing Console -->
            <div class="bg-white rounded-2xl p-6 md:p-8 shadow-sm border border-slate-200 space-y-6">
                <h3 class="text-lg font-bold text-slate-900 border-b pb-3">✍️ 최종 통계 종합 보고서 제출 워크스페이스</h3>
                
                <!-- Student Metadata (Class 1 to 14) -->
                <div class="grid grid-cols-1 sm:grid-cols-4 gap-4">
                    <div>
                        <label class="text-xs font-bold text-slate-500 block mb-1">학급 선택 (1~14반)</label>
                        <select id="student-class-4" class="w-full bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-xs outline-none">
                            <script>
                                for(let i=1; i<=14; i++) { document.write(`<option value="${i}반">3학년 ${i}반</option>`); }
                            </script>
                        </select>
                    </div>
                    <div>
                        <label class="text-xs font-bold text-slate-500 block mb-1">학번 입력</label>
                        <input type="number" id="student-number-4" placeholder="예: 12" class="w-full bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-xs outline-none">
                    </div>
                    <div class="sm:col-span-2">
                        <label class="text-xs font-bold text-slate-500 block mb-1">성명</label>
                        <input type="text" id="student-name-4" placeholder="홍길동" class="w-full bg-slate-50 border border-slate-300 rounded-lg p-2.5 text-xs outline-none">
                    </div>
                </div>

                <!-- Interactive Aggregate Reports from Sections 1,2,3 -->
                <div class="space-y-4">
                    <div>
                        <label class="text-xs font-bold text-indigo-600 block mb-1">📌 [대푯값 영역 통합 의견]</label>
                        <textarea id="opinion-box-1" placeholder="대푯값 탭에서 작성 완료 시 이곳으로 자동 연계 수렴됩니다." class="w-full bg-slate-50 border border-slate-200 rounded-xl p-3 text-xs h-24 outline-none resize-none"></textarea>
                    </div>
                    <div>
                        <label class="text-xs font-bold text-green-600 block mb-1">📌 [산포도 영역 통합 의견]</label>
                        <textarea id="opinion-box-2" placeholder="산포도 탭에서 연산 완료 시 이곳으로 자동 연계 수렴됩니다." class="w-full bg-slate-50 border border-slate-200 rounded-xl p-3 text-xs h-24 outline-none resize-none"></textarea>
                    </div>
                    <div>
                        <label class="text-xs font-bold text-amber-600 block mb-1">📌 [상관관계 영역 통합 의견]</label>
                        <textarea id="opinion-box-3" placeholder="상관관계 탭에서 실험 완료 시 이곳으로 자동 연계 수렴됩니다." class="w-full bg-slate-50 border border-slate-200 rounded-xl p-3 text-xs h-24 outline-none resize-none"></textarea>
                    </div>
                </div>

                <!-- Submit / Clipboard Copy Hub -->
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <button onclick="submitOpinion(4)" class="bg-indigo-600 hover:bg-indigo-700 text-white font-black py-4 px-6 rounded-2xl text-sm transition shadow-sm flex items-center justify-center gap-2">
                        📥 학급 공유보드 게시판에 최종 보고서 등록하기
                    </button>
                    <button onclick="copyToClipboardAndLaunchPadlet()" class="bg-[#FF4081] hover:bg-[#E91E63] text-white font-black py-4 px-6 rounded-2xl text-sm transition shadow-sm flex items-center justify-center gap-2">
                        ⛺ 보고서 복사하고 패들렛에 글쓰기
                    </button>
                </div>
            </div>

            <!-- Gemini AI 수학진단센터 (종합 평가) -->
            <div class="bg-gradient-to-br from-indigo-950 via-slate-900 to-black text-white rounded-3xl p-6 shadow-xl border border-indigo-500/30 space-y-4">
                <h4 class="text-base font-black text-indigo-200">✨ Gemini AI 수학 통계 피드백 센터 (종합 의견 및 탐구 진단)</h4>
                <p class="text-xs text-indigo-300">합산 작성된 대푯값, 산포도, 상관관계 탐구 일체의 종합 성취도를 AI 선생님께 진단 받아보세요.</p>
                <div class="flex gap-2">
                    <button onclick="requestAIFeedback(4)" class="bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold py-3 px-4 rounded-xl transition">📝 내 전체 종합의견 자동 검토받기</button>
                    <input type="text" id="ai-custom-input-4" placeholder="통계 개념 전반에 대해 자율 질문해 보세요." class="flex-grow bg-slate-950/70 border border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-100 outline-none">
                    <button onclick="sendCustomAIQuestion(4)" class="bg-indigo-500 hover:bg-indigo-600 text-white font-bold px-4 rounded-xl text-xs transition">질문</button>
                </div>
                <div id="ai-response-box-4" class="hidden bg-slate-950/80 border border-indigo-500/20 rounded-2xl p-4 text-xs max-h-[300px] overflow-y-auto">
                    <div id="ai-loading-4" class="hidden text-center text-indigo-300 font-bold py-2">대기 중...</div>
                    <div id="ai-text-content-4" class="text-slate-200 space-y-2"></div>
                </div>
            </div>

            <!-- 실시간 학급 우드보드 -->
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-slate-200 space-y-4">
                <div class="flex items-center justify-between border-b pb-2">
                    <h3 class="text-sm font-bold text-slate-900">🔍 실시간 학급 임시 보드 (종합 보고서)</h3>
                    <select id="filter-class-4" onchange="renderOpinions(4)" class="bg-slate-50 border rounded-lg p-1.5 text-xs">
                        <option value="전체">전체 학급 보기</option>
                        <script>
                            for(let i=1; i<=14; i++) { document.write(`<option value="${i}반">${i}반</option>`); }
                        </script>
                    </select>
                </div>
                <div id="realtime-opinion-list-4" class="space-y-4 max-h-[250px] overflow-y-auto">
                    <p class="text-center text-xs text-slate-400 py-6">의견을 불러오는 중입니다...</p>
                </div>
            </div>

            <!-- 실시간 패들렛 연동 보드 (Section 4 하단) -->
            <div class="card p-6 border-2 border-pink-400 bg-rose-50/40 rounded-3xl space-y-4">
                <div class="flex justify-between items-center flex-wrap gap-4">
                    <div>
                        <h3 class="text-pink-600 font-black text-base flex items-center gap-2">⛺ 실시간 학급 패들렛 (Padlet) 연동 게시판</h3>
                        <p class="text-xs text-rose-700">작성한 보고서를 복사한 후 우하단 플러스(+) 단추를 눌러 붙여넣기 해보세요.</p>
                    </div>
                    <div class="flex gap-2 items-center">
                        <input type="text" class="padlet-url-input bg-white border border-slate-300 rounded-lg p-2 text-xs w-48 outline-none">
                        <button class="bg-pink-600 hover:bg-pink-700 text-white font-bold py-2 px-4 rounded-xl text-xs transition" onclick="changePadletUrl(this)">주소 변경</button>
                    </div>
                </div>
                <div class="h-[450px] rounded-2xl overflow-hidden border border-pink-200 bg-white">
                    <iframe class="padlet-iframe w-full h-full border-0" allow="camera;microphone;geolocation"></iframe>
                </div>
            </div>
        </section>

    </main>

    <!-- Custom Beautiful Modal Component -->
    <div class="modal-overlay" id="custom-modal">
        <div class="bg-white rounded-3xl p-6 max-w-sm w-11/12 shadow-2xl text-center space-y-4 border border-slate-100">
            <div id="modal-icon" class="w-12 h-12 rounded-full mx-auto flex items-center justify-center text-xl font-bold bg-blue-50 text-blue-500">
                🔔
            </div>
            <h3 class="text-base font-black text-slate-900" id="modal-title">알림</h3>
            <div class="text-xs text-slate-600 leading-relaxed text-left bg-slate-50 p-4 rounded-xl border border-slate-200 max-h-[150px] overflow-y-auto whitespace-pre-line" id="modal-body">
                내용이 들어갑니다.
            </div>
            <div class="flex justify-center gap-2">
                <button class="bg-slate-900 hover:bg-slate-800 text-white font-bold py-2 px-5 rounded-xl text-xs transition" onclick="closeModal()">
                    닫기
                </button>
                <button class="bg-[#FF4081] hover:bg-[#E91E63] text-white font-bold py-2 px-5 rounded-xl text-xs transition hidden" id="modal-padlet-btn" onclick="redirectToPadlet()">
                    ⛺ 패들렛으로 이동
                </button>
            </div>
        </div>
    </div>

    <!-- JS Logic and Core Calculations Engine -->
    <script>
        // Realtime Local Storage DB Cache Keys
        const LOCAL_STORAGE_KEY = "middle_math_opinion_store_2026_v2";
        const LOCAL_PADLET_KEY = "middle_math_padlet_url_2026";
        
        let padletUrl = localStorage.getItem(LOCAL_PADLET_KEY) || "https://padlet.com/kyrnd323/padlet-84et4m5s0bm041mn";
        let database = null;
        let boardsData = { 1: [], 2: [], 3: [], 4: [] };

        // Firebase Configuration (resilient fallback supported)
        const firebaseConfig = {
            apiKey: "YOUR_FIREBASE_API_KEY",
            authDomain: "YOUR_FIREBASE_AUTH_DOMAIN",
            databaseURL: "YOUR_FIREBASE_DATABASE_URL",
            projectId: "YOUR_FIREBASE_PROJECT_ID",
            storageBucket: "YOUR_FIREBASE_STORAGE_BUCKET",
            messagingSenderId: "YOUR_FIREBASE_MESSAGING_SENDER_ID",
            appId: "YOUR_FIREBASE_APP_ID"
        };

        // Global Chart instances
        let chartA = null, chartB = null;
        let targetChartA = null, targetChartB = null, targetChartC = null;
        let dustChart = null, customDispersionChart = null;
        let weatherChart = null, scatterChart = null;

        // Interactive states
        let currentCalcInput = "0";
        let meanCalcValues = [];
        let scatterData = [];

        const dustDataA = [42, 48, 52, 45, 38, 30, 28, 32, 35, 40, 44, 46];
        const dustDataB = [55, 62, 68, 50, 42, 35, 25, 28, 38, 48, 52, 58];
        const weatherData = [
            { x: 8.5, y: 1.2 }, { x: 4.1, y: 6.8 }, { x: 2.0, y: 8.5 }, { x: 6.0, y: 4.8 },
            { x: 1.5, y: 9.5 }, { x: 7.2, y: 4.0 }, { x: 9.0, y: 0.8 }, { x: 5.5, y: 5.0 }
        ];

        // Core Section Switcher
        function showSection(secId) {
            document.querySelectorAll('.section').forEach(sec => sec.classList.add('hidden'));
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));

            const targetSec = document.getElementById(secId);
            if(targetSec) targetSec.classList.remove('hidden');

            const targetBtn = document.getElementById('btn-' + secId);
            if(targetBtn) targetBtn.classList.add('active');

            // Prevent blocking tab navigation using robust try/catch blocks
            setTimeout(() => {
                if(secId === 'section2') {
                    try { initSection2Charts(); } catch(e) { console.error("chart2 initialization error:", e); }
                    try { calculateDispersion(); } catch(e) { console.error("dispersion calculation error:", e); }
                } else if(secId === 'section3') {
                    try { updateWeatherChart(); } catch(e) { console.error("weather chart error:", e); }
                    try { updateScatterChart(); } catch(e) { console.error("scatter chart error:", e); }
                }
            }, 80);
        }

        // Sub Tab Switcher for Section 1
        function switchSubTab(subId) {
            document.querySelectorAll('.sub-view').forEach(view => view.classList.add('hidden'));
            document.querySelectorAll('.sub-tab-btn').forEach(btn => {
                btn.classList.remove('bg-blue-600', 'text-white');
                btn.classList.add('bg-slate-100', 'text-slate-700');
            });

            const targetSub = document.getElementById(`sub-view-${subId}`);
            if(targetSub) targetSub.classList.remove('hidden');
            
            const targetBtn = document.getElementById(`sub-btn-${subId}`);
            if(targetBtn) {
                targetBtn.classList.add('bg-blue-600', 'text-white');
                targetBtn.classList.remove('bg-slate-100', 'text-slate-700');
            }
        }

        // Global Chart Exporter
        function downloadChartImage(canvasId, fileName) {
            const canvas = document.getElementById(canvasId);
            if(!canvas) {
                showModal("❌ 오류", "이미지화할 그래프 요소를 찾을 수 없습니다.");
                return;
            }
            try {
                const imageURI = canvas.toDataURL('image/png');
                const link = document.createElement('a');
                link.download = `${fileName}_2026.png`;
                link.href = imageURI;
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            } catch (err) {
                showModal("🔒 안내", "화면을 스크린샷 캡쳐하여 이미지를 수동 보존해주시기 바랍니다.");
            }
        }

        // Modal triggers
        function showModal(title, text, showPadletBtn = false, isSuccess = false) {
            document.getElementById('modal-title').innerText = title;
            document.getElementById('modal-body').innerText = text;
            const pBtn = document.getElementById('modal-padlet-btn');
            const icon = document.getElementById('modal-icon');

            icon.innerText = isSuccess ? "🎉" : "🔔";
            pBtn.style.display = showPadletBtn ? 'inline-block' : 'none';
            document.getElementById('custom-modal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('custom-modal').style.display = 'none';
        }

        function redirectToPadlet() {
            closeModal();
            window.open(padletUrl, '_blank');
        }

        // Section 1: Calculations
        function pressCalcKey(key) {
            const screen = document.getElementById('calc-screen');
            if (key === 'C') {
                currentCalcInput = "0";
            } else if (key === '←') {
                currentCalcInput = currentCalcInput.slice(0, -1);
                if (currentCalcInput === "" || currentCalcInput === "-") currentCalcInput = "0";
            } else if (key === '.') {
                if (!currentCalcInput.includes('.')) currentCalcInput += '.';
            } else if (key === '+/-') {
                if (currentCalcInput !== "0") {
                    if (currentCalcInput.startsWith('-')) currentCalcInput = currentCalcInput.slice(1);
                    else currentCalcInput = '-' + currentCalcInput;
                }
            } else {
                if (currentCalcInput === "0") currentCalcInput = key;
                else currentCalcInput += key;
            }
            screen.innerText = currentCalcInput;
        }

        function addCalcValueToList() {
            const val = parseFloat(currentCalcInput);
            if (isNaN(val)) return;
            meanCalcValues.push(val);
            currentCalcInput = "0";
            document.getElementById('calc-screen').innerText = "0";
            updateMeanCalcUI();
        }

        function resetMeanCalc() {
            meanCalcValues = [];
            currentCalcInput = "0";
            document.getElementById('calc-screen').innerText = "0";
            updateMeanCalcUI();
        }

        function updateMeanCalcUI() {
            const listDiv = document.getElementById('mean-calc-list');
            const resultDiv = document.getElementById('mean-calc-result');
            if (meanCalcValues.length === 0) {
                listDiv.innerText = "입력 값: (비어있음)";
                resultDiv.innerText = "평균이 여기에 산출됩니다.";
                return;
            }
            listDiv.innerText = `입력 값: [${meanCalcValues.join(', ')}] (총 ${meanCalcValues.length}개)`;
            const sum = meanCalcValues.reduce((a, b) => a + b, 0);
            const mean = (sum / meanCalcValues.length).toFixed(2);
            resultDiv.innerText = `식: (${meanCalcValues.join('+')}) ÷ ${meanCalcValues.length} ➔ 평균: ${parseFloat(mean)}`;
        }

        function visualizeMedian() {
            const inputStr = document.getElementById('median-visual-input').value;
            const targetDiv = document.getElementById('median-step-by-step');
            let arr = inputStr.split(',').map(n => parseFloat(n.trim())).filter(n => !isNaN(n));
            if (arr.length === 0) {
                targetDiv.innerHTML = `<span class="text-rose-500 font-bold">⚠️ 숫자를 적합하게 입력해 주세요.</span>`;
                return;
            }
            const origin = [...arr];
            arr.sort((a, b) => a - b);
            const n = arr.length;
            const isOdd = n % 2 !== 0;
            let median = 0;
            let stepHtml = "";

            if (isOdd) {
                const midIdx = Math.floor(n / 2);
                median = arr[midIdx];
                stepHtml = `<strong>자료 개수: 홀수 (${n}개)</strong><br>크기 순 정렬 시 가운데 위치한 값 한 개가 중앙값입니다.<br>➔ 중앙값: <span class="text-purple-600 font-black">${median}</span>`;
            } else {
                const midL = (n / 2) - 1;
                const midR = n / 2;
                median = (arr[midL] + arr[midR]) / 2;
                stepHtml = `<strong>자료 개수: 짝수 (${n}개)</strong><br>가운데 위치한 두 값의 평균이 중앙값입니다.<br>➔ 계산: (${arr[midL]} + ${arr[midR]}) ÷ 2 = <span class="text-purple-600 font-black">${median}</span>`;
            }

            const sortedSpanHtml = arr.map((v, i) => {
                let active = false;
                if (isOdd && i === Math.floor(n/2)) active = true;
                if (!isOdd && (i === (n/2 - 1) || i === (n/2))) active = true;
                return `<span class="inline-block px-2 py-1 text-[11px] font-bold rounded ${active ? 'bg-purple-600 text-white' : 'bg-slate-200 text-slate-800'}">${v}</span>`;
            }).join(' ➔ ');

            targetDiv.innerHTML = `
                <div><strong>입력 원본:</strong> [${origin.join(', ')}]</div>
                <div class="my-2"><strong>정렬 순서:</strong> ${sortedSpanHtml}</div>
                <hr class="my-2 border-slate-200">
                <div class="leading-relaxed text-slate-600">${stepHtml}</div>
            `;
        }

        function checkModeQuiz(choice) {
            const feedback = document.getElementById('mode-quiz-feedback');
            if (choice === '최빈') {
                feedback.innerHTML = `<span class="text-green-600 font-bold">🎉 정답입니다! 신발 가게에서는 판매 빈도가 압도적으로 가장 높은 최빈값인 240mm을 많이 발주해야 사업상 손실이 없습니다.</span>`;
            } else if (choice === '평균') {
                feedback.innerHTML = `<span class="text-red-500 font-bold">❌ 오답입니다. 평균인 250mm만 주문하면 실제 방문이 가장 잦은 240mm 구매 고객층을 모두 잃게 됩니다.</span>`;
            } else {
                feedback.innerHTML = `<span class="text-red-500 font-bold">❌ 오답입니다. 중앙값 245mm은 공장에서 제조/유통하지도 않는 규격이므로 발주가 어렵습니다.</span>`;
            }
        }

        function checkAdQ1Answer() {
            const mean = parseFloat(document.getElementById('ad-q1-mean').value);
            const mode = document.getElementById('ad-q1-mode').value.trim();
            if (isNaN(mean) || !mode) {
                showModal("입력 확인", "두 빈칸에 연산 결과를 먼저 기입해 주세요.");
                return;
            }
            if (mean === 11890 && mode === "1000") {
                showModal("🎉 매우 훌륭합니다!", "경품권의 평균 금액(11,890원)과 최빈값(1,000원)을 정확하게 계산하셨습니다!", false, true);
            } else {
                showModal("❌ 오답 안내", "총합 1,189,000원을 총 인원 100명으로 나눈 평균 계산과 수량이 가장 많은 금액을 확인해 보세요.");
            }
        }

        function saveAdMissionToOpinion() {
            const mean = document.getElementById('ad-q1-mean').value;
            const mode = document.getElementById('ad-q1-mode').value;
            const select = document.getElementById('ad-q2-select').value;
            const editAd = document.getElementById('ad-q2-new-text').value.trim();
            const reason = document.getElementById('ad-q2-reason-text').value.trim();

            if (!mean || !mode || !select || !editAd || !reason) {
                showModal("⚠️ 작성 누락", "모든 입력란을 성실히 채우고 저장 버튼을 눌러주세요.");
                return;
            }

            const format = `[교과서 활동: 광고 분석]\n- 광고 경품 연산 ➔ 평균: ${mean}원 / 최빈값: ${mode}원\n- 광고 왜곡 분석: ${select === '과장' ? '과장 광고가 맞다.' : '과장 광고가 아니다.'}\n- 추천 대체 문구: "${editAd}"\n- 판단 이유 및 대푯값 왜곡 논증:\n${reason}`;
            document.getElementById('student-opinion-1').value = format;
            document.getElementById('opinion-box-1').value = format;
            showModal("📥 전송 성공", "대푯값 탐구 의견이 공유 양식 및 종합 대기열로 복사 연동되었습니다.", false, true);
        }

        function calculateRepresentative() {
            const desc = document.getElementById('data-desc-1').value.trim() || "모둠 측정 데이터";
            const inputVal = document.getElementById('data-input-1').value;
            let arr = inputVal.split(',').map(n => parseFloat(n.trim())).filter(n => !isNaN(n));
            if (arr.length === 0) return;

            arr.sort((a,b)=>a-b);
            const n = arr.length;
            const sum = arr.reduce((a,b)=>a+b, 0);
            const mean = (sum / n).toFixed(1);

            let median = 0;
            const mid = Math.floor(n / 2);
            if (n % 2 === 0) {
                median = ((arr[mid - 1] + arr[mid]) / 2).toFixed(1);
            } else {
                median = arr[mid].toFixed(1);
            }

            const freq = {};
            arr.forEach(v => freq[v] = (freq[v] || 0) + 1);
            let maxF = 0;
            let modes = [];
            for (let k in freq) {
                if (freq[k] > maxF) {
                    maxF = freq[k];
                    modes = [k];
                } else if (freq[k] === maxF) {
                    modes.push(k);
                }
            }

            document.getElementById('out-mean').innerText = parseFloat(mean);
            document.getElementById('out-median').innerText = parseFloat(median);
            document.getElementById('out-mode').innerText = modes.join(', ');

            const repChoice = document.getElementById('representative-choice-1').value;
            const repReason = document.getElementById('representative-choice-reason-1').value.trim();
            const synthAns = document.getElementById('final-synthesis-question').value.trim();

            let targetText = `[우리 모둠만의 대푯값 실험결과]\n- 분석 주제: ${desc}\n- 데이터 리스트: [${arr.join(', ')}]\n- 연산치 ➔ 평균: ${parseFloat(mean)} | 중앙값: ${parseFloat(median)} | 최빈값: ${modes.join(', ')}`;
            if (repChoice) {
                targetText += `\n- 채택한 가장 공정한 대푯값: ${repChoice}\n- 의사결정 수학적 판단 근거:\n${repReason}`;
            }
            if (synthAns) {
                targetText += `\n\n[최종 종합 탐구 보고]\n${synthAns}`;
            }

            document.getElementById('student-opinion-1').value = targetText;
            document.getElementById('opinion-box-1').value = targetText;
        }

        // Section 2: Dispersion
        function saveActivity2ToOpinion() {
            const student = document.getElementById('activity2-student-select').value;
            const reason = document.getElementById('activity2-reason-text').value.trim();

            if (!student || !reason) {
                showModal("⚠️ 작성 누락", "득점 분산이 가장 작은 학생 선택과 분포 논거 서술을 모두 작성해 주세요.");
                return;
            }

            const format = `[양궁 사격 과녁 분석]\n- 분산 최소 선수: ${student}\n- 시각적 조밀도 분포 판단 논거:\n${reason}`;
            document.getElementById('student-opinion-2').value = format;
            document.getElementById('opinion-box-2').value = format;
            showModal("📥 전송 성공", "양궁 사격 분석 결과가 산포도 공유 양식 및 종합 대기열로 전송되었습니다.", false, true);
        }

        function calculateDustStatistics() {
            const sumA = dustDataA.reduce((a,b)=>a+b, 0);
            const meanA = (sumA / dustDataA.length).toFixed(1);
            const varA = (dustDataA.reduce((acc, v) => acc + Math.pow(v - meanA, 2), 0) / dustDataA.length).toFixed(2);
            const stdA = Math.sqrt(varA).toFixed(2);

            const sumB = dustDataB.reduce((a,b)=>a+b, 0);
            const meanB = (sumB / dustDataB.length).toFixed(1);
            const varB = (dustDataB.reduce((acc, v) => acc + Math.pow(v - meanB, 2), 0) / dustDataB.length).toFixed(2);
            const stdB = Math.sqrt(varB).toFixed(2);

            document.getElementById('dust-a-mean').innerText = `${meanA} ㎍/㎥`;
            document.getElementById('dust-a-var').innerText = varA;
            document.getElementById('dust-a-std').innerText = `√${varA} ≒ ${stdA} ㎍/㎥`;

            document.getElementById('dust-b-mean').innerText = `${meanB} ㎍/㎥`;
            document.getElementById('dust-b-var').innerText = varB;
            document.getElementById('dust-b-std').innerText = `√${varB} ≒ ${stdB} ㎍/㎥`;

            document.getElementById('dust-stat-results').classList.remove('hidden');
        }

        function saveDustActivityToOpinion() {
            const select = document.getElementById('dust-answer-select').value;
            const reason = document.getElementById('dust-answer-reason').value.trim();

            if (!select || !reason) {
                showModal("⚠️ 작성 누락", "대기 수치 변화가 더 균일한 지역 선택과 표준편차 비교 이유를 작성해 주세요.");
                return;
            }

            let existing = document.getElementById('student-opinion-2').value;
            const format = `\n\n[미세먼지 대기환경 산포도 분석]\n- 오염 변화도가 작은 균일한 구역: ${select}\n- 통계적 산포도 수치 비교 근거:\n${reason}`;
            document.getElementById('student-opinion-2').value = existing + format;
            document.getElementById('opinion-box-2').value = existing + format;
            showModal("📥 전송 성공", "대기환경 오염도 분석 결과가 산포도 대기열로 병합되었습니다.", false, true);
        }

        function calculateDispersion() {
            const desc = document.getElementById('data-desc-2').value.trim() || "기타 통계 조사 자료";
            const inputVal = document.getElementById('data-input-2').value;
            let arr = inputVal.split(',').map(n => parseFloat(n.trim())).filter(n => !isNaN(n));
            if (arr.length === 0) return;

            const n = arr.length;
            const sum = arr.reduce((a,b)=>a+b, 0);
            const mean = sum / n;
            const variance = arr.reduce((acc, v) => acc + Math.pow(v - mean, 2), 0) / n;
            const stddev = Math.sqrt(variance);

            document.getElementById('dispersion-mean').innerText = mean.toFixed(1);
            document.getElementById('dispersion-variance').innerText = variance.toFixed(2);
            document.getElementById('dispersion-stddev').innerText = `√${variance.toFixed(2)} ≒ ${stddev.toFixed(2)}`;

            try { updateCustomDispersionChart(arr, mean); } catch(e) { console.error(e); }

            const targetText = `[나만의 산포도 데이터 분석]\n- 자료 테마: ${desc}\n- 원시 데이터: [${arr.join(', ')}]\n- 산출 결과 ➔ 평균: ${mean.toFixed(1)} | 분산: ${variance.toFixed(2)} | 표준편차: √${variance.toFixed(2)} ≒ ${stddev.toFixed(2)}`;
            document.getElementById('student-opinion-2').value = targetText;
            document.getElementById('opinion-box-2').value = targetText;
        }

        // Initialize Section 2 Charts Safely
        function initSection2Charts() {
            if (typeof Chart === 'undefined') return;

            // Chart A
            try {
                if (chartA) chartA.destroy();
                chartA = new Chart(document.getElementById('chartA').getContext('2d'), {
                    type: 'bar',
                    data: {
                        labels: ['70점 이하', '75점', '80점', '85점', '90점 이상'],
                        datasets: [{
                            label: '밀집형 학생 수',
                            data: [1, 3, 12, 3, 1],
                            backgroundColor: '#3B82F6',
                            borderRadius: 8
                        }]
                    },
                    options: { responsive: true, maintainAspectRatio: false }
                });
            } catch(e) { console.error("chartA init failed:", e); }

            // Chart B
            try {
                if (chartB) chartB.destroy();
                chartB = new Chart(document.getElementById('chartB').getContext('2d'), {
                    type: 'bar',
                    data: {
                        labels: ['70점 이하', '75점', '80점', '85점', '90점 이상'],
                        datasets: [{
                            label: '퍼짐형 학생 수',
                            data: [6, 2, 4, 2, 6],
                            backgroundColor: '#EF4444',
                            borderRadius: 8
                        }]
                    },
                    options: { responsive: true, maintainAspectRatio: false }
                });
            } catch(e) { console.error("chartB init failed:", e); }

            const archOpt = {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: { y: { max: 13, ticks: { stepSize: 2 } } }
            };

            // Archery Target Charts
            try {
                if (targetChartA) targetChartA.destroy();
                targetChartA = new Chart(document.getElementById('targetChartA').getContext('2d'), {
                    type: 'bar',
                    data: { labels: ['7점', '8점', '9점', '10점'], datasets: [{ data: [1, 2, 8, 3], backgroundColor: '#EC4899' }] },
                    options: archOpt
                });
            } catch(e) { console.error("targetChartA init failed:", e); }

            try {
                if (targetChartB) targetChartB.destroy();
                targetChartB = new Chart(document.getElementById('targetChartB').getContext('2d'), {
                    type: 'bar',
                    data: { labels: ['7점', '8점', '9점', '10점'], datasets: [{ data: [0, 1, 12, 1], backgroundColor: '#10B981' }] },
                    options: archOpt
                });
            } catch(e) { console.error("targetChartB init failed:", e); }

            try {
                if (targetChartC) targetChartC.destroy();
                targetChartC = new Chart(document.getElementById('targetChartC').getContext('2d'), {
                    type: 'bar',
                    data: { labels: ['7점', '8점', '9점', '10점'], datasets: [{ data: [3, 4, 4, 3], backgroundColor: '#3B82F6' }] },
                    options: archOpt
                });
            } catch(e) { console.error("targetChartC init failed:", e); }

            // Dust Line Chart
            try {
                if (dustChart) dustChart.destroy();
                dustChart = new Chart(document.getElementById('dustChart').getContext('2d'), {
                    type: 'line',
                    data: {
                        labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                        datasets: [
                            {
                                label: '지역 A (부산)',
                                data: dustDataA,
                                borderColor: '#3B82F6',
                                backgroundColor: 'rgba(59, 130, 246, 0.05)',
                                tension: 0.3,
                                fill: true
                            },
                            {
                                label: '지역 B (서울)',
                                data: dustDataB,
                                borderColor: '#EF4444',
                                backgroundColor: 'rgba(239, 68, 68, 0.05)',
                                tension: 0.3,
                                fill: true
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: { y: { min: 15, max: 75 } }
                    }
                });
            } catch(e) { console.error("dustChart init failed:", e); }
        }

        function updateCustomDispersionChart(dataArray, meanValue) {
            if (typeof Chart === 'undefined') return;
            const canvasEl = document.getElementById('customDispersionChart');
            if(!canvasEl) return;
            const ctx = canvasEl.getContext('2d');
            const sorted = [...dataArray].sort((a,b)=>a-b);

            try {
                if (customDispersionChart) customDispersionChart.destroy();
                customDispersionChart = new Chart(ctx, {
                    type: 'scatter',
                    data: {
                        datasets: [
                            {
                                label: '변량 개별 분포',
                                data: sorted.map(v => ({ x: v, y: 1 })),
                                backgroundColor: '#6366F1',
                                pointRadius: 8
                            },
                            {
                                label: '평균선',
                                data: [{ x: meanValue, y: 0.6 }, { x: meanValue, y: 1.4 }],
                                type: 'line',
                                borderColor: '#EF4444',
                                borderWidth: 2,
                                borderDash: [6, 4],
                                fill: false,
                                pointRadius: 0
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            x: { title: { display: true, text: '수치 축값' } },
                            y: { display: false, min: 0.5, max: 1.5 }
                        }
                    }
                });
            } catch(e) { console.error("customDispersionChart update failed:", e); }
        }

        // Section 3: Correlation
        function updateWeatherChart() {
            if (typeof Chart === 'undefined') return;
            const canvasEl = document.getElementById('weatherChart');
            if(!canvasEl) return;
            const ctx = canvasEl.getContext('2d');

            try {
                if (weatherChart) weatherChart.destroy();
                weatherChart = new Chart(ctx, {
                    type: 'scatter',
                    data: {
                        datasets: [{
                            label: '기상 측정 관측쌍',
                            data: weatherData,
                            backgroundColor: '#D97706',
                            pointRadius: 8
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            x: { title: { display: true, text: '일조 시간 (시간)' }, min: 0, max: 10 },
                            y: { title: { display: true, text: '평균 운량 (할)' }, min: 0, max: 10 }
                        }
                    }
                });
            } catch(e) { console.error("weatherChart failed:", e); }
        }

        function saveWeatherActivityToOpinion() {
            const select = document.getElementById('weather-answer-select').value;
            const reason = document.getElementById('weather-answer-reason').value.trim();

            if (!select || !reason) {
                showModal("⚠️ 작성 누락", "상관관계 퀴즈 선택과 판단 사유 설명을 작성해 주세요.");
                return;
            }

            const format = `[기상 조건 산점도 분석]\n- 판별된 관계 유형: ${select === '음' ? '음의 상관관계' : '기타 상관관계'}\n- 산점도 구름 하락세 기울기 관측 원인 소견:\n${reason}`;
            document.getElementById('student-opinion-3').value = format;
            document.getElementById('opinion-box-3').value = format;
            showModal("📥 전송 성공", "기상 산점도 분석 내용이 상관관계 대기열로 복사 연동되었습니다.", false, true);
        }

        function checkMathCommunication(choice) {
            const feedback = document.getElementById('math-comm-feedback');
            feedback.classList.remove('hidden');

            if (choice === '하은') {
                feedback.className = "p-4 rounded-xl border bg-green-50 border-green-200 text-green-700 font-bold text-xs";
                feedback.innerText = "🎉 하은이의 소견이 맞습니다! 돔 형태나 포물선은 증가와 감소가 중첩되어 일정한 단방향 연관세가 성립되지 않으므로 교과 통계 법칙상 '상관관계가 없다'라고 정의하는 것이 옳습니다.";
            } else {
                feedback.className = "p-4 rounded-xl border bg-red-50 border-red-200 text-red-700 font-bold text-xs";
                feedback.innerText = "❌ 준우의 주장은 성립되지 않습니다. 구간별 증가 하강 경향이 상쇄되기 때문에 두 요인은 상관관계를 띠지 않는 것으로 취급합니다.";
            }
        }

        function loadScenario(type) {
            const body = document.querySelector('#scatter-table tbody');
            if(!body) return;
            body.innerHTML = '';

            const thX = document.getElementById('th-x');
            const thY = document.getElementById('th-y');

            if (type === 'negative') {
                thX.innerText = "하루 게임 시간 (X축, 분)";
                thY.innerText = "수학 성적 (Y축, 점)";
                scatterData = [
                    { id: "학생1", x: 120, y: 65 },
                    { id: "학생2", x: 180, y: 45 },
                    { id: "학생3", x: 30, y: 95 },
                    { id: "학생4", x: 90, y: 80 },
                    { id: "학생5", x: 150, y: 55 }
                ];
            } else {
                thX.innerText = "발 크기 (X축, mm)";
                thY.innerText = "수학 성적 (Y축, 점)";
                scatterData = [
                    { id: "학생1", x: 230, y: 85 },
                    { id: "학생2", x: 240, y: 55 },
                    { id: "학생3", x: 270, y: 90 },
                    { id: "학생4", x: 260, y: 70 },
                    { id: "학생5", x: 250, y: 45 }
                ];
            }

            scatterData.forEach(row => {
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td class="p-2 border">${row.id}</td>
                    <td class="p-2 border"><input type="number" value="${row.x}" class="table-x-val w-20 bg-slate-100 p-1 rounded text-center"></td>
                    <td class="p-2 border"><input type="number" value="${row.y}" class="table-y-val w-20 bg-slate-100 p-1 rounded text-center"></td>
                `;
                body.appendChild(tr);
            });

            try { updateScatterChart(); } catch(e) { console.error(e); }
        }

        function addTableRow() {
            const body = document.querySelector('#scatter-table tbody');
            if(!body) return;
            const num = body.children.length + 1;
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td class="p-2 border">학생${num}</td>
                <td class="p-2 border"><input type="number" value="100" class="table-x-val w-20 bg-slate-100 p-1 rounded text-center"></td>
                <td class="p-2 border"><input type="number" value="80" class="table-y-val w-20 bg-slate-100 p-1 rounded text-center"></td>
            `;
            body.appendChild(tr);
        }

        function updateScatterChart() {
            if (typeof Chart === 'undefined') return;
            const canvasEl = document.getElementById('scatterChart');
            if(!canvasEl) return;
            const ctx = canvasEl.getContext('2d');

            const rows = document.querySelectorAll('#scatter-table tbody tr');
            const dataSet = [];
            rows.forEach(row => {
                const id = row.cells[0].innerText;
                const x = parseFloat(row.querySelector('.table-x-val').value) || 0;
                const y = parseFloat(row.querySelector('.table-y-val').value) || 0;
                dataSet.push({ id, x, y });
            });

            scatterData = dataSet;

            try {
                if (scatterChart) scatterChart.destroy();
                scatterChart = new Chart(ctx, {
                    type: 'scatter',
                    data: {
                        datasets: [{
                            label: '학생 데이터셋 분포',
                            data: scatterData.map(d => ({ x: d.x, y: d.y })),
                            backgroundColor: '#4F46E5',
                            pointRadius: 9
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            x: { title: { display: true, text: 'X축 변량 수치' } },
                            y: { title: { display: true, text: 'Y축 변량 수치' } }
                        }
                    }
                });
            } catch(e) { console.error("scatterChart failed:", e); }
        }

        function checkCorrelationAnswer() {
            const answer = document.getElementById('user-correlation-answer').value;
            const thXText = document.getElementById('th-x').innerText;

            if (!answer) {
                showModal("선택 미입력", "판단한 상관관계를 목록에서 선택해 주세요.");
                return;
            }

            if (thXText.includes("게임 시간")) {
                if (answer === '음') {
                    showModal("🎉 매우 정확합니다!", "게임 시간이 증폭될수록 수학 성적은 하강 추세를 보이는 '음의 상관관계'가 뚜렷합니다.", false, true);
                } else {
                    showModal("❌ 오답", "점들이 우하향 사선 흐름으로 내리막길을 타는지 직접 도표를 판독하세요.");
                }
            } else {
                if (answer === '없음') {
                    showModal("🎉 매우 정확합니다!", "신체 발 크기 치수와 수학적 성향 점수는 어떤 연관세나 비례성도 없어 '상관관계가 없음'에 속합니다.", false, true);
                } else {
                    showModal("❌ 오답", "X변량이 커짐에 따라 Y의 일관된 증가 혹은 감소 경향이 완전히 깨져서 무작위로 분산된 모습을 관찰하세요.");
                }
            }
        }

        function saveScatterExperimentToOpinion() {
            const thX = document.getElementById('th-x').innerText;
            const thY = document.getElementById('th-y').innerText;
            const answer = document.getElementById('user-correlation-answer').value;

            let typeName = answer === '음' ? '음의 상관관계' : (answer === '양' ? '양의 상관관계' : '상관관계 없음');
            let explanation = `X축(${thX})와 Y축(${thY}) 변량의 실시간 모의배치를 관측한 결과, 뚜렷한 [${typeName}] 성향을 보임을 확인하였습니다. 추가적으로 이 분석을 통해 두 요인이 깊은 연관세를 띠더라도 직접적인 인과관계는 쉽게 예단할 수 없음을 인지하였습니다.`;

            const format = `[우리 모둠의 가상 시뮬레이션 산점도 실험]\n- X축(${thX}) vs Y축(${thY})\n- 판정 상관관계: [${typeName}]\n- 시뮬레이션 소견 및 인과관계 성립 유무 고찰:\n${explanation}`;
            document.getElementById('student-opinion-3').value = format;
            document.getElementById('opinion-box-3').value = format;
            showModal("📥 전송 성공", "가상 산점도 실험 결과 의견이 상관관계 대기열로 복사 연동되었습니다.", false, true);
        }

        // Clipboard and final submission
        function copyToClipboardAndLaunchPadlet() {
            const cls = document.getElementById('student-class-4').value;
            const num = document.getElementById('student-number-4').value.trim();
            const name = document.getElementById('student-name-4').value.trim();

            const op1 = document.getElementById('opinion-box-1').value.trim();
            const op2 = document.getElementById('opinion-box-2').value.trim();
            const op3 = document.getElementById('opinion-box-3').value.trim();

            if (!num || !name) {
                showModal("학적 미기재", "성함과 학년, 학번을 적고 복사를 진행해 주세요.");
                return;
            }

            const clipboardContent = `[${cls} ${num}번 ${name} 통계 실험실 최종 종합 보고서]\n\n${op1}\n\n${op2}\n\n${op3}`;

            // Create hidden, focused textarea for robust fallback in iFrames
            const dummyTextarea = document.createElement("textarea");
            dummyTextarea.value = clipboardContent;
            dummyTextarea.style.position = 'fixed';
            dummyTextarea.style.top = '0';
            dummyTextarea.style.left = '0';
            dummyTextarea.style.width = '2em';
            dummyTextarea.style.height = '2em';
            dummyTextarea.style.padding = '0';
            dummyTextarea.style.border = 'none';
            dummyTextarea.style.outline = 'none';
            dummyTextarea.style.boxShadow = 'none';
            dummyTextarea.style.background = 'transparent';
            
            document.body.appendChild(dummyTextarea);
            dummyTextarea.focus();
            dummyTextarea.select();
            dummyTextarea.setSelectionRange(0, 99999); // Mobile compatibility
            
            let success = false;
            try {
                success = document.execCommand("copy");
            } catch (err) {
                console.error("클립보드 복사 실행 중 오류:", err);
            }
            document.body.removeChild(dummyTextarea);

            if (success) {
                showModal(
                    "📋 클립보드 복사 성공!",
                    `작성한 종합 보고서 원고가 복사되었습니다.\n\n[확인]을 터치하면 패들렛 보드로 이동할 수 있습니다. 플러스(+) 단추를 누르고 제목에 '${cls} ${num}번 ${name}'을 기재한 뒤 붙여넣기(Ctrl+V)하여 제출해 주세요!`,
                    true,
                    true
                );
            } else {
                showModal(
                    "복사 실패",
                    `안전 정책에 의해 자동 복사가 불가합니다. 본문 내용을 길게 터치하여 수동 복제해 주십시오.\n\n[제출 내용]:\n${clipboardContent}`,
                    true
                );
            }
        }

        // Change Padlet URL dynamically (teachers & students)
        function changePadletUrl(btnEl) {
            const container = btnEl.parentElement;
            const input = container.querySelector('.padlet-url-input');
            const targetUrl = input.value.trim();
            if(!targetUrl) {
                showModal("입력 오류", "유효한 패들렛 주소(URL)를 기입해 주십시오.");
                return;
            }

            padletUrl = targetUrl;
            localStorage.setItem(LOCAL_PADLET_KEY, targetUrl);

            // Propagate to all Padlet visual inputs and iframes
            document.querySelectorAll('.padlet-url-input').forEach(inp => inp.value = targetUrl);
            document.querySelectorAll('.padlet-iframe').forEach(ifr => ifr.src = targetUrl);

            // Optional Firebase cloud synchronization
            if(database) {
                try {
                    database.ref('global_padlet_config').set({ url: targetUrl });
                } catch(e) {
                    console.warn("Could not sync Padlet config to Database:", e);
                }
            }

            showModal("⛺ 패들렛 링크 저장 완료", "신규 패들렛 주소가 저장되었습니다. 현재 단독 다운로드 및 로컬 브라우저 상태를 포함해 영구 바인딩됩니다.", false, true);
        }

        function submitToPadlet(sectionNum) {
            const cls = document.getElementById(`student-class-${sectionNum}`).value;
            const num = document.getElementById(`student-number-${sectionNum}`).value.trim();
            const name = document.getElementById(`student-name-${sectionNum}`).value.trim();
            const opText = document.getElementById(`student-opinion-${sectionNum}`).value.trim();

            if(!num || !name || !opText) {
                return showModal("입력 확인", "학번, 이름 및 의견 내용을 채우신 다음 복사를 진행해 주세요.");
            }

            const clipboardContent = `[${cls} ${num}번 ${name} 의견 제출]\n\n${opText}`;
            
            const dummyTextarea = document.createElement("textarea");
            dummyTextarea.value = clipboardContent;
            dummyTextarea.style.position = 'fixed';
            dummyTextarea.style.top = '0';
            dummyTextarea.style.left = '0';
            dummyTextarea.style.width = '2em';
            dummyTextarea.style.height = '2em';
            dummyTextarea.style.padding = '0';
            dummyTextarea.style.border = 'none';
            dummyTextarea.style.outline = 'none';
            dummyTextarea.style.boxShadow = 'none';
            dummyTextarea.style.background = 'transparent';
            
            document.body.appendChild(dummyTextarea);
            dummyTextarea.focus();
            dummyTextarea.select();
            dummyTextarea.setSelectionRange(0, 99999);
            
            let success = false;
            try {
                success = document.execCommand("copy");
            } catch(err) {
                console.error("클립보드 복사 실행 중 오류:", err);
            }
            document.body.removeChild(dummyTextarea);

            if(success) {
                showModal(
                    "📋 클립보드 복사 성공!", 
                    `작성하신 의견이 복사되었습니다.\n\n확인을 누르면 패들렛 게시판으로 이동합니다. 패들렛 화면에서 아래쪽 '+'를 터치하고 제목에 '${cls} ${num}번 ${name}'을 적은 뒤, 글쓰기 본문 칸을 꾹 누르고 '붙여넣기'하여 등록해 주세요!`, 
                    true,
                    true
                );
            } else {
                showModal(
                    "알림", 
                    `브라우저 제한으로 자동 복사가 차단되었을 수 있습니다. 아래 내용을 직접 길게 눌러 선택하고 복사한 후 패들렛으로 이동해 주세요.\n\n[제출 내용]:\n${clipboardContent}`,
                    true
                );
            }
        }

        // Structure Opinion Boards locally and over firebase
        function submitOpinion(sectionNum) {
            const cls = document.getElementById(`student-class-${sectionNum}`).value;
            const num = document.getElementById(`student-number-${sectionNum}`).value.trim();
            const name = document.getElementById(`student-name-${sectionNum}`).value.trim();
            const opText = document.getElementById(`student-opinion-${sectionNum}`).value.trim();

            if(!num || !name || !opText) {
                showModal("학적 및 내용 누락", "학반, 학번, 성함을 모두 기입하고 탐구 내용을 채운 상태에서 등록을 터치해 주세요.");
                return;
            }

            const opinionData = {
                class: cls,
                meta: `${cls} ${num}번 ${name}`,
                text: opText,
                timestamp: new Date().toLocaleTimeString()
            };

            boardsData[sectionNum].unshift(opinionData);
            localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(boardsData));

            if(database) {
                try {
                    database.ref(`opinions_sec_${sectionNum}`).push(opinionData);
                } catch(err) {
                    console.warn("Firebase push error, keeping local boards:", err);
                    renderOpinions(sectionNum);
                }
            } else {
                renderOpinions(sectionNum);
                showModal("📥 임시 등록 완료", "클라우드 서버 오프라인 상태이므로 본 브라우저 로컬 저장소에 안전하게 임시 보존되었습니다.", false, true);
            }
        }

        function renderOpinions(sectionNum) {
            const filterClass = document.getElementById(`filter-class-${sectionNum}`).value;
            const listBox = document.getElementById(`realtime-opinion-list-${sectionNum}`);
            if(!listBox) return;
            listBox.innerHTML = '';

            let list = boardsData[sectionNum] || [];
            if(filterClass !== '전체') {
                list = list.filter(item => item.class === filterClass);
            }

            if(list.length === 0) {
                listBox.innerHTML = `<p class="text-center text-xs text-slate-400 py-6">해당 학급에 등록된 탐구 데이터가 아직 없습니다.</p>`;
                return;
            }

            list.forEach(item => {
                const card = document.createElement('div');
                card.className = "bg-slate-50 border border-slate-200 rounded-2xl p-4 space-y-2 text-xs relative";
                card.innerHTML = `
                    <div class="flex justify-between font-black text-slate-700">
                        <span>👤 ${item.meta}</span>
                        <span class="text-slate-400 font-normal">${item.timestamp || ''}</span>
                    </div>
                    <div class="text-slate-600 leading-relaxed whitespace-pre-wrap">${item.text}</div>
                `;
                listBox.appendChild(card);
            });
        }

        // Gemini AI MD & Table Parser
        function parseMarkdown(text) {
            let lines = text.split('\n');
            let inTable = false;
            let tableHtml = '';
            let resultHtml = '';

            for (let line of lines) {
                line = line.trim();
                if (line.startsWith('|')) {
                    if (!inTable) {
                        inTable = true;
                        tableHtml = '<div class="overflow-x-auto my-4 shadow-lg border border-indigo-500/20 rounded-xl"><table class="w-full text-xs text-left border-collapse">';
                    }
                    let cells = line.split('|').map(c => c.trim()).filter((c, i, a) => i > 0 && i < a.length - 1);
                    if (line.includes('---')) {
                        continue;
                    }
                    tableHtml += '<tr class="border-b border-indigo-500/10 hover:bg-indigo-500/5 bg-white">';
                    for (let cell of cells) {
                        tableHtml += `<td class="p-3 font-semibold text-slate-800 border">${cell}</td>`;
                    }
                    tableHtml += '</tr>';
                } else {
                    if (inTable) {
                        inTable = false;
                        tableHtml += '</table></div>';
                        resultHtml += tableHtml;
                        tableHtml = '';
                    }
                    
                    let formattedLine = line.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
                    if (formattedLine.startsWith('- ') || formattedLine.startsWith('* ')) {
                        resultHtml += `<li class="ml-4 list-disc text-slate-700 my-1">${formattedLine.substring(2)}</li>`;
                    } else if (formattedLine.startsWith('### ')) {
                        resultHtml += `<h4 class="text-indigo-600 font-extrabold text-sm mt-4 mb-2">${formattedLine.substring(4)}</h4>`;
                    } else if (formattedLine.startsWith('## ')) {
                        resultHtml += `<h3 class="text-indigo-800 font-black text-base mt-5 mb-2">${formattedLine.substring(3)}</h3>`;
                    } else if (formattedLine.length > 0) {
                        resultHtml += `<p class="my-2 leading-relaxed text-slate-700">${formattedLine}</p>`;
                    }
                }
            }
            if (inTable) {
                tableHtml += '</table></div>';
                resultHtml += tableHtml;
            }
            return resultHtml;
        }

        async function callGemini(userPrompt, systemInstruction) {
            const apiKey = ""; 
            const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=${apiKey}`;
            
            const payload = {
                contents: [{ parts: [{ text: userPrompt }] }],
                systemInstruction: { parts: [{ text: systemInstruction }] }
            };

            const delayTimes = [1000, 2000, 4000];
            for (let attempt = 0; attempt < 3; attempt++) {
                try {
                    const response = await fetch(url, {
                        method: "POST",
                        headers: { "Content-Type": "application/json" },
                        body: JSON.stringify(payload)
                    });
                    if (!response.ok) throw new Error(`API error ${response.status}`);
                    const result = await response.json();
                    const text = result.candidates?.[0]?.content?.parts?.[0]?.text;
                    if (text) return text;
                    else throw new Error("Empty content.");
                } catch (error) {
                    if (attempt < 2) {
                        await new Promise(resolve => setTimeout(resolve, delayTimes[attempt]));
                    }
                }
            }
            throw new Error("Gemini API call timed out.");
        }

        async function requestAIFeedback(sectionNum) {
            const textContent = document.getElementById(`student-opinion-${sectionNum}`).value.trim();
            const textBox = document.getElementById(`ai-text-content-${sectionNum}`);
            const responseBox = document.getElementById(`ai-response-box-${sectionNum}`);
            const loadingBox = document.getElementById(`ai-loading-${sectionNum}`);

            if (!textContent) {
                showModal("📝 입력 부족", "해당 단원의 탐구 의견을 먼저 작성하거나 전송해 주십시오.");
                return;
            }

            responseBox.classList.remove("hidden");
            loadingBox.classList.remove("hidden");
            textBox.innerHTML = "";

            let systemPrompt = "";
            if (sectionNum === 1) {
                systemPrompt = "당신은 중학교 3학년 수학 통계(대푯값) 전문 친절한 교사입니다. 마크다운 테이블 양식(| 지표 | 의견 분석 | 피드백 |)을 사용하여, 학생의 대푯값 선정 타당성과 왜곡 광고 해석을 표 형식으로 채점 및 처방해 주십시오.";
            } else if (sectionNum === 2) {
                systemPrompt = "당신은 중학교 3학년 수학 통계(산포도 - 분산과 표준편차) 전문 친절한 교사입니다. 루트(√)를 적극 수식으로 사용해, 분산 및 대기환경 오염도 분포 해석 타당성을 표 양식(| 오염 변화 | 표준편차 비교 | 수학적 제안 |)과 조목별 개조식으로 검토해 주십시오.";
            } else if (sectionNum === 3) {
                systemPrompt = "당신은 중학교 3학년 수학 통계(상관관계와 인과관계) 전문 친절한 교사입니다. 상관관계와 인과관계의 엄격한 차이를 구조적인 마크다운 표 양식(| 두 지표 | 상관 추세 | 인과 성립 유무 |)을 활용해 명징하게 체크해 주십시오.";
            } else {
                systemPrompt = "당신은 중학교 3학년 통계(대푯값, 산포도, 상관관계)를 총괄 진단하는 수학교사입니다. 학생의 종합 의견서 성취 수준을 평가하여 마크다운 테이블과 개조식 요약 피드백으로 작성해 주십시오.";
            }

            try {
                const feedback = await callGemini(textContent, systemPrompt);
                loadingBox.classList.add("hidden");
                textBox.innerHTML = parseMarkdown(feedback);
            } catch (error) {
                loadingBox.classList.add("hidden");
                textBox.innerHTML = `<span class="text-rose-500 font-bold">⚠️ 피드백 연동 제한</span><br>API 연결이 지연되었습니다. 잠시 후 피드백 받기를 다시 눌러주십시오.`;
            }
        }

        async function sendCustomAIQuestion(sectionNum) {
            const query = document.getElementById(`ai-custom-input-${sectionNum}`).value.trim();
            const textBox = document.getElementById(`ai-text-content-${sectionNum}`);
            const responseBox = document.getElementById(`ai-response-box-${sectionNum}`);
            const loadingBox = document.getElementById(`ai-loading-${sectionNum}`);

            if (!query) {
                showModal("💬 질문 미입력", "궁금한 통계 수학적 개념을 먼저 작성한 후 질문해 보세요.");
                return;
            }

            responseBox.classList.remove("hidden");
            loadingBox.classList.remove("hidden");
            textBox.innerHTML = "";

            const systemPrompt = "당신은 중학교 3학년 수학 통계 전문 똑똑한 AI 선생님입니다. 학생의 통계 수학 질문에 대해, 구조화된 마크다운 표(| 용어 | 실생활 예시 |) 및 넘버링된 상세 구조로 조목조목 친절하게 존댓말로 답해 주십시오.";

            try {
                const ans = await callGemini(query, systemPrompt);
                loadingBox.classList.add("hidden");
                textBox.innerHTML = parseMarkdown(ans);
            } catch (error) {
                loadingBox.classList.add("hidden");
                textBox.innerHTML = `질문 처리에 일시적인 오류가 발생했습니다.`;
            }
        }

        // Cloud & Local Initializer
        function initApp() {
            // Load Local Padlet URL
            document.querySelectorAll('.padlet-url-input').forEach(inp => inp.value = padletUrl);
            document.querySelectorAll('.padlet-iframe').forEach(ifr => ifr.src = padletUrl);

            // Synchronize local reports
            const cached = localStorage.getItem(LOCAL_STORAGE_KEY);
            if(cached) {
                try {
                    boardsData = JSON.parse(cached);
                } catch(e) { console.error(e); }
            }

            // Fallback to Firebase compatibility setup
            if(firebaseConfig.apiKey !== "YOUR_FIREBASE_API_KEY" && typeof firebase !== 'undefined') {
                try {
                    firebase.initializeApp(firebaseConfig);
                    database = firebase.database();

                    // Listen to Padlet global config updates
                    database.ref('global_padlet_config').on('value', (snap) => {
                        const val = snap.val();
                        if(val && val.url) {
                            padletUrl = val.url;
                            document.querySelectorAll('.padlet-url-input').forEach(inp => inp.value = padletUrl);
                            document.querySelectorAll('.padlet-iframe').forEach(ifr => ifr.src = padletUrl);
                        }
                    });

                    // Sync public boards
                    [1, 2, 3, 4].forEach(sectionNum => {
                        database.ref(`opinions_sec_${sectionNum}`).on('value', (snap) => {
                            const data = snap.val();
                            boardsData[sectionNum] = [];
                            if(data) {
                                for(let key in data) {
                                    boardsData[sectionNum].push(data[key]);
                                }
                                boardsData[sectionNum].reverse();
                            }
                            renderOpinions(sectionNum);
                        });
                    });
                } catch(err) {
                    console.warn("Firebase offline alternative launched:", err);
                    [1, 2, 3, 4].forEach(num => renderOpinions(num));
                }
            } else {
                [1, 2, 3, 4].forEach(num => renderOpinions(num));
            }

            visualizeMedian();
            loadScenario('negative');
        }

        window.onload = function() {
            initApp();
        };
    </script>
</body>
</html>
