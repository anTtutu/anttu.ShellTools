#!/bin/bash

# ============================================================
# IntelliJ IDEA 日志清理脚本
# 适用目录: ~/Library/Logs/JetBrains/IntelliJIdea2025.3
#
# 清理规则:
#   *.json              - JSON 日志/指标文件
#   *.csv               - CSV 数据文件
#   threadDumps*        - 线程转储目录
#   jcef_chromium*.log  - Chromium 缓存目录
#   idea.log.[0-9]*     - 归档日志文件 (如 idea.log.1, idea.log.2.gz)
#   idea.[0-9]*.log     - 归档日志 (idea.1.log, idea.2.log)
#   idea.[0-9]*.log.*   - 压缩归档日志 (idea.1.log.gz)
# ============================================================

set -e

# ---------- 颜色定义 ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ---------- 配置 ----------
IDEA_DIR="$HOME/Library/Logs/JetBrains/IntelliJIdea2025.3"
# 如果你用的是其他版本，改这里即可，例如:
# IDEA_DIR="$HOME/Library/Logs/JetBrains/IntelliJIdea2026.1"

# ---------- 匹配模式 (支持通配符) ----------
PATTERNS=(
    "*.json"
    "*.csv"
    "threadDumps*"
    "jcef_chromium*.log"	# jcef_chromium_98288.log
    "idea.log.[0-9]*"           # idea.log.1, idea.log.2
    "idea.log.*.gz"             # idea.log.1.gz
    "idea.log.*.zip"            # idea.log.1.zip
    "idea.log.[0-9]*.[0-9]*"    # idea.log.2026-07-15.1    
    "idea.[0-9]*.log"           # idea.1.log, idea.2.log (数字在中间)
    "idea.[0-9]*.log.*"         # idea.1.log.gz, idea.2.log.zip (压缩版)
)

# ---------- 函数: 检查目录 ----------
check_directory() {
    if [ ! -d "$IDEA_DIR" ]; then
        echo -e "${RED}❌ 目录不存在: $IDEA_DIR${NC}"
        exit 1
    fi
    echo -e "${BLUE}📂 目标目录: $IDEA_DIR${NC}"
    echo ""
}

# ---------- 函数: 收集匹配项 ----------
collect_matches() {
    local items=()
    cd "$IDEA_DIR" || exit 1
    
    for pattern in "${PATTERNS[@]}"; do
        if [[ "$pattern" == *"."* ]] && [[ "$pattern" != *"*"*"/"* ]]; then
            # 文件模式
            while IFS= read -r file; do
                if [ -f "$file" ]; then
                    items+=("$file")
                fi
            done < <(find . -maxdepth 1 -type f -name "$pattern" 2>/dev/null || true)
        else
            # 目录模式
            while IFS= read -r dir; do
                if [ -d "$dir" ]; then
                    items+=("$dir")
                fi
            done < <(find . -maxdepth 1 -type d -name "$pattern" 2>/dev/null || true)
        fi
    done
    
    # 去重
    if [ ${#items[@]} -gt 0 ]; then
        printf "%s\n" "${items[@]}" | sort -u
    fi
}

# ---------- 函数: 显示匹配项 ----------
show_matches() {
    local matches=("$@")
    local count=${#matches[@]}
    
    if [ $count -eq 0 ]; then
        echo -e "${GREEN}✅ 没有找到匹配的垃圾文件，目录已干净。${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}📋 找到 ${count} 个匹配项:${NC}"
    echo ""
    
    local total_size=0
    for item in "${matches[@]}"; do
        if [ -d "$item" ]; then
            size=$(du -sk "$item" 2>/dev/null | cut -f1)
            human_size=$(du -sh "$item" 2>/dev/null | cut -f1)
            echo -e "  📁 ${CYAN}$item${NC} ${BLUE}(大小: $human_size)${NC}"
        else
            size=$(stat -f%z "$item" 2>/dev/null || echo "0")
            human_size=$(ls -lh "$item" 2>/dev/null | awk '{print $5}')
            if [[ "$item" == *.gz ]] || [[ "$item" == *.zip ]]; then
                echo -e "  📦 ${CYAN}$item${NC} ${BLUE}(大小: $human_size, 已压缩)${NC}"
            else
                echo -e "  📄 ${CYAN}$item${NC} ${BLUE}(大小: $human_size)${NC}"
            fi
        fi
        total_size=$((total_size + size))
    done
    
    echo ""
    # 转换为人类可读格式
    if [ $total_size -gt 1048576 ]; then
        total_human=$(echo "scale=2; $total_size/1048576" | bc)
        echo -e "${BLUE}📊 匹配项总大小: ${total_human} GB${NC}"
    elif [ $total_size -gt 1024 ]; then
        total_human=$(echo "scale=2; $total_size/1024" | bc)
        echo -e "${BLUE}📊 匹配项总大小: ${total_human} MB${NC}"
    else
        echo -e "${BLUE}📊 匹配项总大小: ${total_size} KB${NC}"
    fi
    
    # 目录总大小
    dir_total=$(du -sk . 2>/dev/null | cut -f1)
    if [ $dir_total -gt 1048576 ]; then
        dir_human=$(echo "scale=2; $dir_total/1048576" | bc)
        echo -e "${BLUE}📊 当前目录总大小: ${dir_human} GB${NC}"
    elif [ $dir_total -gt 1024 ]; then
        dir_human=$(echo "scale=2; $dir_total/1024" | bc)
        echo -e "${BLUE}📊 当前目录总大小: ${dir_human} MB${NC}"
    else
        echo -e "${BLUE}📊 当前目录总大小: ${dir_total} KB${NC}"
    fi
    
    echo ""
    return 0
}

# ---------- 函数: 二次确认 ----------
confirm_deletion() {
    local count=$1
    
    echo -e "${YELLOW}⚠️  即将删除 ${count} 个匹配项，此操作不可恢复！${NC}"
    echo ""
    
    # 第一次确认: 输入 y 或 Y
    read -p "是否继续？(y/N): " confirm1
    
    if [[ ! "$confirm1" =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}🛑 已取消操作，没有删除任何文件。${NC}"
        exit 0
    fi
    
#    echo ""
#    echo -e "${RED}🔴 第二次确认: 请输入 'yes' 或 'YES' 以执行删除${NC}"
#    read -p "请输入确认词: " confirm2
    
#    if [[ ! "$confirm2" =~ ^[Yy][Ee][Ss]$ ]]; then
#        echo -e "${GREEN}🛑 二次确认失败，已取消操作，没有删除任何文件。${NC}"
#        exit 0
#    fi
    
    echo ""
    echo -e "${GREEN}✅ 二次确认通过，开始清理...${NC}"
    echo ""
}

# ---------- 函数: 执行删除 ----------
do_delete() {
    local matches=("$@")
    local count=${#matches[@]}
    
    echo -e "${YELLOW}🗑️  正在删除...${NC}"
    echo ""
    
    local deleted=0
    local failed=0
    
    for item in "${matches[@]}"; do
        if rm -rf "$item" 2>/dev/null; then
            echo -e "  ${GREEN}✓${NC} 已删除: $item"
            ((deleted++))
        else
            echo -e "  ${RED}✗${NC} 删除失败: $item (可能需要权限)"
            ((failed++))
        fi
    done
    
    echo ""
    echo -e "${GREEN}✅ 清理完成！${NC}"
    echo -e "   ${GREEN}✓${NC} 成功删除: $deleted 个"
    if [ $failed -gt 0 ]; then
        echo -e "   ${RED}✗${NC} 删除失败: $failed 个"
    fi
    
    # 显示清理后目录大小
    if [ -d "$IDEA_DIR" ]; then
        cd "$IDEA_DIR" || return
        new_total=$(du -sk . 2>/dev/null | cut -f1)
        if [ $new_total -gt 1048576 ]; then
            new_human=$(echo "scale=2; $new_total/1048576" | bc)
            echo -e "${BLUE}📊 清理后目录总大小: ${new_human} GB${NC}"
        elif [ $new_total -gt 1024 ]; then
            new_human=$(echo "scale=2; $new_total/1024" | bc)
            echo -e "${BLUE}📊 清理后目录总大小: ${new_human} MB${NC}"
        else
            echo -e "${BLUE}📊 清理后目录总大小: ${new_total} KB${NC}"
        fi
    fi
}

# ---------- 主流程 ----------
main() {
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  IntelliJ IDEA 日志清理工具${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    
    # 1. 检查目录
    check_directory
    
    # 2. 切换到目标目录
    cd "$IDEA_DIR" || exit 1
    
    # 3. 收集匹配项
    echo -e "${YELLOW}🔍 正在扫描匹配的文件和文件夹...${NC}"
    echo ""
    
    matched_items=()
    while IFS= read -r item; do
        matched_items+=("$item")
    done < <(collect_matches)
    
    # 4. 显示匹配项
    if ! show_matches "${matched_items[@]}"; then
        exit 0
    fi
    
    # 5. 二次确认（第一次输入 y/Y，第二次必须输入 yes/YES）
    confirm_deletion "${#matched_items[@]}"
    
    # 6. 执行删除
    do_delete "${matched_items[@]}"
    
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  清理完成！${NC}"
    echo -e "${GREEN}========================================${NC}"
}

# ---------- 执行 ----------
main "$@"
