@Library('devops-shared-lib')_

environment {
    LC_ALL = 'en_US.UTF-8'
    LANG    = 'en_US.UTF-8'
    LANGUAGE = 'en_US.UTF-8'
}
BUILD_TRIGGER_BY = "${currentBuild.getBuildCauses()[0].userId}"

HASH_COMMIT = getTag.split("-")
sh(returnStdout: true, script:""" for i in ${HASH_COMMIT[@]}; do flag=0 && if [ ${#i} != 8 ] && [ ${#i} != 40 ]; then flag=1 && continue; else if HASH_COMMIT=$(git rev-parse $i 2>/dev/null); then echo $i is a git hash-commit. && exit; else flag=1 && continue; fi; fi; done; if [ $flag == 1 ]; then echo There is no hash in this tag.; fi """)

try
{   
    if (hash_commit_exist=0)
    {

    }
    if (getTag().contains("-mock") && getTag().contains("-chroot"))
    {
        build_node="mock-sintezm"
        DONT_CLEAN_CHROOT = true
        BUILD_WITH_CLEANING = false
    }
    else if (getTag().contains("-mock"))
    {
        build_node="mock-sintezm"
        BUILD_WITH_CLEANING = false
    }
    else if (getTag().contains("-chroot"))
    {
        DONT_CLEAN_CHROOT = true
    }
    else if (getTag().contains("-svace"))
    {
        build_node="mock-svace-sintezm"
        BUILD_WITH_CLEANING = false
    }
    else if (getTag().contains("-head"))
    {
        BUILD_HEAD = true
    }
}
catch(err)
{
    println("Возникло исключение при обработке параметров передаваемых через tag")
}
if (SVACE.toBoolean() && BUILD_WITH_CLEANING.toBoolean())
{
    println("вы выбрали неправильную конфигурацию я не могу чистить пакеты и проводить статический анализ кода")
    Hudson.istance.stopJob(PROJECT) 
}
else if (SVACE.toBoolean())
{
    build_node="mock-svace-sintezm"
}
else if (BUILD_WITH_CLEANING.toBoolean())
{
    build_node="mock-cleaner-sintezm"
    println("#"*140 + "\n" + "-"*140 + "\n" + "#"*140 + "\n" + " ПАКЕТ СОБИРАЕТСЯ С ЧИСТКОЙ " + "\n" + "#"*140 + "\n" + "-"*140 + "\n" + "#"*140) 
}
else
{
    build_node="mock-sintezm" 
}

try
{
    GITUSER = gitlabUserUsername;
    println("---------- Tag выпустил следующий пользователь >>> " + GITUSER + " ----------")
}
catch(err)
{
    GITUSER = "none"
    println("Сборка проекта из src пользователем $BUILD_TRIGGER_BY")
}


node(build_node)
{
    catchError(buildResult: 'FAILURE') 
    {
//################################################################################//
//############### этап очистки рабочего пространства перед сборкой ###############//
//################################################################################//
        stage ("""cleaning workspace before build""")
        {
            sh """sudo rm -rdf /home/jenkins/chroots/${OS}/${PROJECT}/root/ | true 
                  sudo rm -rdf /home/jenkins/workspace/${JOB_NAME}/* | true 
                  sudo rm -rdf /home/jenkins/workspace/log-build-${PROJECT} |true 
                  sudo rm -rdf /var/lib/mock/${PROJECT}_${OS} |true
                  sudo rm -rdf /var/lib/mock/${PROJECT}_${OS}-bootstrap |true   
                  sudo rm -rdf /var/cache/mock/${PROJECT}_${OS}* |true
                  sudo rm -rdf /home/jenkins/params-build/${JOB_NAME} | true """
        if (SVACE.toBoolean())
        {
            sh """sudo rm -rdf /home/jenkins/svace-results/${PROJECT} | true
                  sudo rm -rdf /home/jenkins/workspace/${JOB_NAME}/.* | true"""
        }
        if (BUILD_WITH_CLEANING.toBoolean())
        {
            sh """sudo rm -rf /root/Report/${PROJECT}* | true
                  rm -rf /home/jenkins/Report/${PROJECT}* | true
                  rm -rf /home/jenkins/workspace/${JOB_NAME}/* | true
                  sudo rm -rf /var/lib/mock/${PROJECT}_${OS} 
                  sudo rm -rf /var/lib/mock/${PROJECT}_${OS}-bootstrap  
                  sudo rm -rf /var/cache/mock/${PROJECT}_${OS}*"""
        }
        }
//##############################################################################//
//############### этап сборки пакетов из srpm или исходных кодов ###############//
//##############################################################################//
        stage ("""buid in mock""")
        {
            sh """mkdir -p /home/jenkins/params-build/${JOB_NAME}"""
            dir("/home/jenkins/params-build/${JOB_NAME}")
            {
                checkout([$class: 'GitSCM', branches: [[name: 'master']], 
                        userRemoteConfigs: [[credentialsId: """GitLab""", url:"""git@gitlab.draszi.fintech.ru:devops/build-config.git"""]],
                        extensions: [[$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: true, recursiveSubmodules: true,]]])
            }
            NAME = "jenkins"
            println("--------------" + GITUSER + "-----------------------")
            TRIGER_DEV_REPO=sh(returnStdout: true, script:"""set +x && wget --spider -S 'https://nexus.draszi.fintech.ru/repository/devolopment-dump/${GITUSER}/${OS}/repodata/repomd.xml' 2>&1 | grep 'HTTP/' | awk '{print \$2}' """).trim();
                updateGitlabCommitStatus name: 'build', state: 'pending'
                build_number=env.BUILD_ID
                os_release=OS.replace(".", "_")
                println("Пакету будет присвоен %{dist} = " + os_release)
                //if(GITUSER == "none" || TRIGER_DEV_REPO != "200") 
                if(TRIGER_DEV_REPO != "200")
                {
                    POWER="0"    
                }
                else
                {
                    POWER="1"
                }
                sh """ssh root@10.128.128.124 'mkdir -p /logserver/${JOB_NAME}/${build_number}/'"""
                prepare_mock_config(JOB_NAME, OS, PROJECT, GITUSER, POWER)
                if (BUILD_WITH_CLEANING.toBoolean())
                {   
                    // не отрабатывает на перенос каретки
                    sh """sed -i 's|cleaner-tools\\\nenabled=0|cleaner-tools\\\nenabled=1|' ${PROJECT}.cfg"""
                }
                sh """ set +x
                       irclog2html ${PROJECT}.cfg -s simplett
                       scp ./${PROJECT}.cfg.html root@10.128.128.124:/logserver/${JOB_NAME}/${build_number}/
                       rm -rf ${PROJECT}.cfg.html
                       set -x """
                println("Ссылка на config сборки >>> " + "http://logserver.draszi.fintech.ru/${JOB_NAME}/${build_number}/${PROJECT}.cfg.html")
                sh "mkdir ./result"
                if (SVACE.toBoolean())
                {   // before update svace-3.3.0-x64-linux
                    sh """sed -i "s/20.20.0.50/10.10.0.50/" ${PROJECT}.cfg
                          mock -r ${PROJECT}.cfg --rootdir=/home/jenkins/chroots/${OS}/${PROJECT}/root/ init &>./result/init.log
                          mock -r ${PROJECT}.cfg --rootdir=/home/jenkins/chroots/${OS}/${PROJECT}/root/ --copyin /etc/mock/svace-3.4.240109-x64-linux /opt/
                          mock -r ${PROJECT}.cfg --rootdir=/home/jenkins/chroots/${OS}/${PROJECT}/root/ --shell ln -s /opt/svace-3.4.240109-x64-linux/bin/svace /usr/bin/svace
                          mock -r ${PROJECT}.cfg --rootdir=/home/jenkins/chroots/${OS}/${PROJECT}/root/ --shell /usr/bin/svace init /
                          mock -r ${PROJECT}.cfg --rootdir=/home/jenkins/chroots/${OS}/${PROJECT}/root/ --shell chown mockbuild:1004 /.svace-dir"""
                }
                else
                {
                sh """ ${SUBSTITUTE_USER_AND_DO} mock -r ${PROJECT}.cfg --rootdir=/home/jenkins/chroots/${OS}/${PROJECT}/root/ init &>./result/init.log"""
                }
            if (SOURCE.isEmpty())
            {
                branch = getBranch()
                println("---------- Я буду производить сборку этой ветки >>> " + branch + " ----------")
                sh """ rm -rf ./.git* """
                checkout([$class: 'GitSCM', branches: [[name: branch]], 
                                            userRemoteConfigs: [[credentialsId: """${CREDENTIALS}""", url:"""git@${HOSTNAME}:${GROUP}/${PROJECT}.git"""]],
                                            extensions: [[$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: true, recursiveSubmodules: true, trackingSubmodules: true]]])
                updateGitlabCommitStatus name: 'build', state: 'running'
                sh """find /home/jenkins/workspace/${JOB_NAME}/ -name ".gitignore" -exec rm {} ";" """
                if (GITUSER == "none")
                {
                    println("---------- Сборка запущена через jenkins пользователем ${BUILD_TRIGGER_BY} по последнему tag-у ветки ${BRANCH}  ----------")
                }
                else
                {
                    println("---------- Tag выпустил следующий пользователь >>> " + GITUSER + " ----------")  
                }              
                tag = getTag()
                println("---------- Пользователь присвоил tag-у следующее значение >>> " + tag + " ----------")
                def commit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                println("---------- Пользователь выпустил tag на следующий commit >>> " + commit + " ----------")
                version = tag.split("-")[0]
                sh """sed -i 's/{?version}/${version}/' ${PROJECT}.spec"""
                if (tag.contains("-"))
                {
                        release = tag.split("-")[1]
                        // дублируется для скрипта USF.sh
                        sh """sed -i 's/%{?dist}/${release}%{?dist}/' ${PROJECT}.spec"""
                }
                else
                {
                        release = "0"
                        // дублируется для скрипта USF.sh
                        sh """sed -i 's/%{?dist}/${release}%{?dist}/' ${PROJECT}.spec"""
                }
                println("---------- пакету будет присовено следующее значение release >>> " + release + " ----------")
                prepare_mock_config(JOB_NAME, OS, PROJECT, GITUSER, POWER)
                sh """cp /home/jenkins/params-build/${JOB_NAME}/USF.sh /home/jenkins/workspace/${JOB_NAME}/
                      sed -i "s/(this-touch-os)/${OS}/g" USF.sh 
                      sed -i "s/(this-touch-group)/${REPOSITORY}/g" USF.sh 
                      sed -i "s/(this-touch-url)/gitlab.draszi.fitech.ru/g" USF.sh
                      bash USF.sh ${os_release} "build_git_project"
                      rm -rf USF.sh"""
                // Блок кода для перехода в конкретные коммиты по файлику .gitcommit_for_build
                if (fileExists("/home/jenkins/workspace/${JOB_NAME}/.gitcommit_for_build"))
                {
                    if (BUILD_HEAD == true)
                    {
                        println("Проект cобирается и последнего коммита ветки ${branch}")
                    }
                    else
                    {
                        println("Проект cобирается из commit указанных пользователем:")
                        sh """cat .gitcommit_for_build && set +x
                              while IFS= read -r line; do 
                                  cd_path=\$(echo \$line | awk '{print \$1}')
                                  select_commit=\$(echo \$line | awk '{print \$2}')
                                  cd \${cd_path}
                                  git checkout \${select_commit} 
                                  cd -
                              done < .gitcommit_for_build """
                    }
                }
                else
                {
                    println("Проект cобирается и последнего коммита ветки ${branch}")
                }
                sh """ if [ \$(ls src/resources &>/dev/null ; echo \$?) != 0 ]; then mv resources/* ./ | true ; else mv src/resources/* ./ ; fi """
                List list_archives = sh(returnStdout: true, script:""" echo `if [ \$(ls src/src &>/dev/null ; echo \$?) != 0 ]; then ls ./src ; else ls ./src/src && mv ./src/src/* ./src && rm -rf ./src/src ; fi` """).trim().split(' ');
                for (a in list_archives)
                {
                    if (a == null || a.isEmpty()) 
                    {
                        break;
                    }
                    else 
                    {
                        println("Сейчас буду упаковывать в архив >>> " + a)
                        if (a.contains(".tar.gz"))
                        {
                            sh """cd ./src/${a} && shopt -s dotglob && tar -czf ../../${a} * """
                        }
                        else if (a.contains(".tar.xz"))
                        {
                            sh """cd ./src/${a} && shopt -s dotglob && tar -cJf ../../${a} * """
                        }
                        else if (a.contains(".tar.bz2"))
                        {
                            sh """cd ./src/${a} && shopt -s dotglob && tar -cjf ../../${a} * """
                        }
                        else if (a.contains(".tgz"))
                        {
                            sh """cd ./src/${a} && shopt -s dotglob && tar -czf ../../${a} * """
                        }
                        else if (a.contains(".tar.lz"))
                        {
                            sh """cd ./src/${a} && shopt -s dotglob && tar -cvf ../../${a} * """
                        }
                        else if (a.contains(".lzma"))
                        {
                            //sh """cd ./src/${a} && shopt -s dotglob && unlzma ../../${a} * """
                        }
                        else if (a.contains(".lzo"))
                        {
                            //sh """cd ./src/${a} && shopt -s dotglob && tar -czf ${a} -C ./src ${a}"""
                        }
                        else if (a.contains(".zst"))
                        {
                            sh """cd ./src/${a} && shopt -s dotglob && tar --use-compress-program=unzstd -xvf ../../${a} * """
                        }
                        else if (a.contains(".zip"))
                        {
                            sh """cd ./src/${a} && shopt -s dotglob && zip -r ../../${a} * """
                        }
                        else if (a.endsWith(".tar"))
                        {
                            sh """cd ./src/${a} && shopt -s dotglob && tar -cf ../../${a} * """
                        }
                        else
                        {
                            sh """shopt -s dotglob && tar -czf ${a}.tar.gz -C ./src ${a}"""        
                        }
                    }
                }
                sh """cp /home/jenkins/params-build/${JOB_NAME}/check_src.sh /home/jenkins/workspace/${JOB_NAME}/
                      bash ./check_src.sh"""
                SPEC = sh(returnStdout: true, script:"""find ./ -maxdepth 1 -name "*.spec" | cut -d '/' -f2-""").trim();
                println(SPEC)
                if (SVACE.toBoolean())
                {
                    sh """sed -i "s/20.20.0.50/10.10.0.50/" ${PROJECT}.cfg"""
                }
                sh """${SUBSTITUTE_USER_AND_DO} mock -r ${PROJECT}.cfg  -N -n --buildsrpm --spec=${SPEC} --sources=./ --resultdir=./result/ --rootdir=/home/jenkins/chroots/${OS}/${PROJECT}/root/ 2>/dev/null"""
                result_dir = "mock-result-" + PROJECT
                                // блок выполнения скриптов перед сборкой
                try
                {
                    if(PRE_BUILD_SCRIPT.isEmpty())
                    {
                        println("пресборочный скрипт не исполнялся, поле пустое")
                    }
                    else
                    {
                        println("пользователь ${BUILD_TRIGGER_BY} применил слудующий скрипт >>>> ${PRE_BUILD_SCRIPT}")
                        sh """ ${PRE_BUILD_SCRIPT} """
                    }
                }
                catch(err)
                {
                    println ("параметра в PRE_BUILD_SCRIPT нет в окружении сборки ")
                }
                if (BUILD_WITH_CLEANING.toBoolean())
                {
                    if (SUBSTITUTE_USER_AND_DO.trim() == "sudo")
                    {
                        workplace = "/root/Report/" + sh(returnStdout: true, script:"""set +x \n echo `find ./result/ -name "*.src.rpm" | cut -d "/" -f3- | rev | cut -d "." -f3- | rev `""").trim();
                        sh """sudo touch /root/ignore.txt
                              sudo echo "${IGNORE_FILES}" >> /root/ignore.txt
                              sudo sed -i 's/\\s\\+\\//\\n\\//g' /root/ignore.txt """
                    }
                    else
                    {
                        workplace = "/home/jenkins/Report/" + sh(returnStdout: true, script:"""set +x \n echo `find ./result/ -name "*.src.rpm" | cut -d "/" -f3- | rev | cut -d "." -f3- | rev `""").trim();
                        sh """ touch /home/jenkins/ignore.txt
                               echo "${IGNORE_FILES}" >> /home/jenkins/ignore.txt
                               sed -i 's/\\s\\+\\//\\n\\//g' /home/jenkins/ignore.txt """
                    }
                    sh """export PYTHONUNBUFFERED=1 # чтоб убрать вертолеты
                          if [ ! -f ./${PROJECT}-ignore.txt ]
                          then
                              mkdir ${result_dir}
                              ${SUBSTITUTE_USER_AND_DO} src_cleaner -r ${PROJECT}.cfg -N -n -s ./result/*.src.rpm --resultdir=${result_dir} --rootdir /home/jenkins/chroots/${OS}/${PROJECT}/root/ --without_helicopter  
                          else
                              mkdir ${result_dir}
                              ${SUBSTITUTE_USER_AND_DO} src_cleaner -r ${PROJECT}.cfg -N -n -s ./result/*.src.rpm -f ./${PROJECT}-ignore.txt --resultdir=${result_dir} --rootdir /home/jenkins/chroots/${OS}/${PROJECT}/root/ --without_helicopter
                          fi"""
                    if (SUBSTITUTE_USER_AND_DO.trim() == "sudo")
                    {
                        sh """sudo chown -R jenkins:jenkins /root"""
                    }  
                }
                else
                {
                    sh """${SUBSTITUTE_USER_AND_DO} mock -r ${PROJECT}.cfg ${RPMBUILD_OPT} -N -n --rebuild ./result/*.src.rpm --resultdir=${result_dir} --rootdir=/home/jenkins/chroots/${OS}/${PROJECT}/root/ 2>/dev/null"""
                    sh """sudo chown -R jenkins:jenkins /home/jenkins/workspace/${JOB_NAME} || true"""
                    sh """mkdir ${result_dir}/fold_debug
                          find ${result_dir}/ -type f -name "*debugsource*" -o -name "*debuginfo*" -exec mv {} ${result_dir}/fold_debug/ ';'
                          rm -rf ${result_dir}/*.src.rpm """
                    sh """mkdir ${result_dir}/fold_binar
                          mv ${result_dir}/*.rpm ${result_dir}/fold_binar/"""   
                }
            }
            else
            {
                name_pkgs = SOURCE.split('/')[-1]
                println("Сборка из пакета >>> " + SOURCE)
                sh """set +x
                      mkdir /home/jenkins/workspace/${JOB_NAME}/USF/ 
                      cp /home/jenkins/params-build/${JOB_NAME}/USF.sh /home/jenkins/workspace/${JOB_NAME}/USF/
                      curl ${SOURCE} -o ./USF/${name_pkgs} 2>/dev/null
                      cd ./USF/ 
                      sed -i "s/(this-touch-os)/${OS}/g" USF.sh
                      sed -i "s/(this-touch-group)/${REPOSITORY}/g" USF.sh
                      sed -i "s/(this-touch-url)/nexus.draszi.fintech.ru/g" USF.sh
                      rpm2cpio ${name_pkgs} | cpio -idmv && rm -rf ${name_pkgs}
                      bash USF.sh ${os_release} && cd - """
                SPEC = sh(returnStdout: true, script:"""basename -a ./USF/*.spec""").trim();
                sh """set +x
                      irclog2html ./USF/${SPEC} -s simplett
                      scp ./USF/${SPEC}.html root@10.128.128.124:/logserver/${JOB_NAME}/${build_number}/
                      rm -rf ./USF/${SPEC}.html """
                println("Ссылка на SPEC файл >>> " + "http://logserver.draszi.fintech.ru/${JOB_NAME}/${build_number}/${SPEC}.html")
                sh """cd ./USF/ && ${SUBSTITUTE_USER_AND_DO} mock -r ../${PROJECT}.cfg  -N -n --buildsrpm --spec=${SPEC} --sources=./ --resultdir=../result/ --rootdir=/home/jenkins/chroots/${OS}/${PROJECT}/root/ 2>/dev/null && cd - && rm -rf ./USF """           
                result_dir = "mock-result-" + PROJECT
                // блок выполнения скриптов перед сборкой повторяется
                try
                {
                    if(PRE_BUILD_SCRIPT.isEmpty())
                    {
                        println("пресборочный скрипт не исполнялся, поле пустое")
                    }
                    else
                    {
                        println("пользователь ${BUILD_TRIGGER_BY} применил слудующий скрипт >>>> ${PRE_BUILD_SCRIPT}")
                        sh """ ${PRE_BUILD_SCRIPT} """
                    }
                }
                catch(err)
                {
                    println ("параметра в PRE_BUILD_SCRIPT нет в окружении сборки ")
                }
                if (BUILD_WITH_CLEANING.toBoolean())
                {
                    if (SUBSTITUTE_USER_AND_DO.trim() == "sudo")
                    {
                        workplace = "/root/Report/" + sh(returnStdout: true, script:"""set +x \n echo `find ./result/ -name "*.src.rpm" | cut -d "/" -f3- | rev | cut -d "." -f3- | rev `""").trim();
                        sh """sudo touch /root/ignore.txt
                              sudo echo "${IGNORE_FILES}" >> /root/ignore.txt
                              sudo sed -i 's/\\s\\+\\//\\n\\//g' /root/ignore.txt """
                    }
                    else
                    {
                        workplace = "/home/jenkins/Report/" + sh(returnStdout: true, script:"""set +x \n echo `find ./result/ -name "*.src.rpm" | cut -d "/" -f3- | rev | cut -d "." -f3- | rev `""").trim();
                        sh """ touch /home/jenkins/ignore.txt
                               echo "${IGNORE_FILES}" >> /home/jenkins/ignore.txt
                               sed -i 's/\\s\\+\\//\\n\\//g' /home/jenkins/ignore.txt """
                    }
                    sh """export PYTHONUNBUFFERED=1 # чтоб убрать вертолеты
                          if [ ! -f ./${PROJECT}-ignore.txt ]
                          then
                              mkdir ${result_dir}
                              ${SUBSTITUTE_USER_AND_DO} src_cleaner -r ${PROJECT}.cfg -N -n -s ./result/*.src.rpm --resultdir=${result_dir} --rootdir /home/jenkins/chroots/${OS}/${PROJECT}/root/ --without_helicopter
                          else
                              mkdir ${result_dir}
                              ${SUBSTITUTE_USER_AND_DO} src_cleaner -r ${PROJECT}.cfg -N -n -s ./result/*.src.rpm -f ./${PROJECT}-ignore.txt --resultdir=${result_dir} --rootdir /home/jenkins/chroots/${OS}/${PROJECT}/root/ --without_helicopter
                          fi"""
                    if (SUBSTITUTE_USER_AND_DO.trim() == "sudo")
                    {
                        sh """sudo chown -R jenkins:jenkins /root"""
                    }
                }
                else
                {
                    sh """${SUBSTITUTE_USER_AND_DO} mock -r ${PROJECT}.cfg ${RPMBUILD_OPT} -N -n --rebuild ./result/*.src.rpm --resultdir ${result_dir} --rootdir=/home/jenkins/chroots/${OS}/${PROJECT}/root/ 2>/dev/null"""
                    sh """sudo chown -R jenkins:jenkins /home/jenkins/workspace/${JOB_NAME} || true"""
                    sh """mkdir ${result_dir}/fold_debug
                          find ${result_dir}/ -type f -name "*debugsource*" -o -name "*debuginfo*" -exec mv {} ${result_dir}/fold_debug/ ';'
                          rm -rf ${result_dir}/*.src.rpm """
                    sh """mkdir ${result_dir}/fold_binar
                          mv ${result_dir}/*.rpm ${result_dir}/fold_binar/"""    
                }
                sh """sudo chown -R jenkins:jenkins /home/jenkins/workspace/${JOB_NAME} || true """
            }
            if (SVACE.toBoolean())
            {
                sh """mkdir /home/jenkins/workspace/${JOB_NAME}/.svace-dir """
                sh """${SUBSTITUTE_USER_AND_DO} mock -r ${PROJECT}.cfg --rootdir=/home/jenkins/chroots/${OS}/${PROJECT}/root/ --copyout /.svace-dir /home/jenkins/svace-results/${PROJECT}/.svace-dir"""
                sh """sudo chown -R jenkins:jenkins /home/jenkins/svace-results/${PROJECT}/ || true """
                sh """tar -czf .svace-dir.tar.gz -C /home/jenkins/svace-results/${PROJECT}/ .svace-dir/ && cp ./.svace-dir.tar.gz /home/jenkins/svace-results/${PROJECT}"""
            }
        }
        stage ("""post build comands""")
        {
            try
            {
                if(POST_BUILD_SCRIPT.isEmpty())
                {
                    println("постсборочный скрипты не исполнялся, поле пустое")
                }
                else
                {
                    println("пользователь ${BUILD_TRIGGER_BY} применил слудующий скрипт >>>> ${POST_BUILD_SCRIPT}")
                    sh """ ${POST_BUILD_SCRIPT} """
                }
            }
            catch(err)
            {
                println ("параметра в POST_BUILD_SCRIPT нет в окружении сборки ")
            }
            // рассмотреть необходимость этого шага????
        }
        stage("""sending svace result""")
        {
            if (SVACE.toBoolean())
            {
                sh """curl -X POST -F title="${PROJECT}" -F branch=master -F sv_file=@/home/jenkins/svace-results/${PROJECT}/.svace-dir.tar.gz http://svace.lab.fintech.ru/svupload/v1/post/sintez"""
                //def job = Jenkins.instance.getItemByFullName(JOB_NAME)
                //job.setResult(Result.SUCCESS)
                //currentBuild.result = 'SUCCESS'
                //job.doStop()
                //Hudson.istance.stopJob(PROJECT)
                currentBuild.getRawBuild().getExecutor().interrupt(Result.SUCCESS)
                sleep(1)
            }
        }
//####################################################//
//############### этап подписи пакетов ###############//
//####################################################//
        stage ("""signing rpm packages""")
        {
            println("-"*140 + "\n" + " этап подписи пакетов " + "\n" + "-"*140)
            sh """cp /home/jenkins/.gnupg/passphrase.sh ./
                  bash ./passphrase.sh """
            if (BUILD_WITH_CLEANING.toBoolean())
            {
                // распаковка отчета
                NAME_SRC =sh(returnStdout: true, script:"""basename -a result/*.src.rpm | rev | cut -b9- | rev""").trim();
                println("поиск отчета с именем >>> " + NAME_SRC)
                sh """ tar -xf ${result_dir}/${NAME_SRC}.tar.gz -C ${result_dir}"""
                sh """ cd ${result_dir}  
                       shopt -s extglob
                       rm -rf !(src-cleaned|src-original|rpm-cleaned|rpm-original|${NAME_SRC}.tar.gz)"""
                println("Поиск и перемещенеие пакетов") 
                sh """ find ${result_dir}/ -type f -name "*.rpm" -exec rpmsign --delsign {} ';'
                       find ${result_dir}/ -type f -name "*.rpm" -exec rpmsign --addsign {} ';' """
                List list_rpm = sh(returnStdout: true, script:"""echo `find ${result_dir}/ -type f -name "*.rpm" `""").trim().split(' ');
                check_signature(list_rpm)       
            }
            else
            {
                sh """find ./ -name "*.rpm" -exec rpm --delsign {} ';'
                      find ./ -name "*.rpm" -exec rpm --addsign {} ';' """
                List list_rpm = sh(returnStdout: true, script:"""echo `find ./ -type f -name "*.rpm" `""").trim().split(' ');
                check_signature(list_rpm)
            }
        }
//####################################################################################//
//############### этап загрузки результатов сборки в репозиторий Nexus ###############//
//####################################################################################//
        stage ("""download result for NEXUS""")
        {
            withCredentials([usernamePassword(credentialsId: 'Nexus', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')])
            {
                sh """ set +x
                       touch /home/jenkins/.netrc
                       echo "machine nexus.draszi.fintech.ru" > /home/jenkins/.netrc
                       echo "login ${USERNAME}">> /home/jenkins/.netrc
                       echo "password ${PASSWORD}">> /home/jenkins/.netrc """
                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
                //++++++++++++++ загрузка результатов сборки srpm-cleaner ++++++++++++++//
                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
                if (BUILD_WITH_CLEANING.toBoolean())
                {
                    List list_dir = ["rpm-cleaned", "rpm-original", "src-cleaned", "src-original"]
                    List list_debug_download = []
                    List list_binar_download = []
                    for (directory in list_dir)
                    {
                        dir("${result_dir}/${directory}/")
                        {
                            if (directory == "rpm-cleaned")
                            { 
                                url_nexus = "https://nexus.draszi.fintech.ru/repository/sintezm-" + OS[-3..-1] + "/clean-pkgs"
                            }
                            else if (directory == "src-cleaned")
                            {
                                url_nexus = "https://nexus.draszi.fintech.ru/repository/source-code/${OS}-clean" 
                            }
                            else if (directory == "rpm-original")
                            {
                                url_nexus = "https://nexus.draszi.fintech.ru/repository/sintezm-" + OS[-3..-1] + "/origin-pkgs"
                            }
                            else
                            {
                                url_nexus = "https://nexus.draszi.fintech.ru/repository/source-code/${OS}-origin"
                            } 
                            print(url_nexus)
                            sh """mkdir ./debug
                                  find ./ -type f -name "*debug*" -exec mv {} ./debug/ ';' """
                            List list_debug = sh(returnStdout: true, script:"""echo `find ./debug/ -type f -name "*.rpm" | cut -d '/' -f3-`""").trim().split(' ');
                            if (list_debug[0].isEmpty())
                            {
                                println("---------- в директории ${workplace}/${directory} ни одного debug пакета ----------");
                            }
                            else
                            {
                                println("В debug репозиторий я загружу следующие пакеты " + "\n" + list_debug.join("\n"))
                                for (pkgs in list_debug)
                                {
                                    letter = pkgs[0].toLowerCase()
                                    try
                                    {
                                        if (GITUSER == "a.shaldybin" && tag.contains("-RC") || GITUSER == "v.chemizov" && tag.contains("-RC") || SOURCE.isEmpty() == false)
                                        {
                                            sh """set +x && curl -n --upload-file ./debug/${pkgs} ${url_nexus}/debug-${REPOSITORY}/${letter}/ 2>/dev/null"""
                                        }
                                        else
                                        {
                                            sh """set +x && curl -n --upload-file ./debug/${pkgs} https://nexus.draszi.fintech.ru/repository/devolopment-dump/${GITUSER}/${OS}/ 2>/dev/null"""
                                        }
                                    }
                                    catch(err)
                                    {
                                        sh """set +x && curl -n --upload-file ./debug/${pkgs} ${url_nexus}/debug-${REPOSITORY}/${letter}/ 2>/dev/null"""
                                    } 
                                }    
                                sh """rm -rf ./debug""" 
                                for (name_pkgs in list_debug)
                                {                    
                                    letter = name_pkgs[0].toLowerCase()
                                    try
                                    {
                                        if (GITUSER == "a.shaldybin" && tag.contains("-RC") || GITUSER == "v.chemizov" && tag.contains("-RC") || SOURCE.isEmpty() == false)
                                        {
                                            link="${url_nexus}/debug-${REPOSITORY}/${letter}/${name_pkgs}"
                                            list_debug_download.add(link)
                                        }
                                        else
                                        {
                                            link="https://nexus.draszi.fintech.ru/repository/devolopment-dump/${GITUSER}/${OS}/${name_pkgs}"
                                            list_debug_download.add(link)
                                        }
                                    }
                                    catch(err)
                                    {
                                         link="${url_nexus}/debug-${REPOSITORY}/${letter}/${name_pkgs}"
                                         list_debug_download.add(link)
                                    }     
                                }
                            }
                            sh """echo `find ./ -type f -name '*.rpm'` """
                            List list_binar = sh(returnStdout: true, script:"""echo `find ./ -type f -name "*.rpm" | cut -d '/' -f2-`""").trim().split(' ');
                            println("В репозиторий я загружу следующие пакеты " + "\n" + list_binar.join("\n"))
                            for (bin_pkgs in list_binar)
                            {
                                letter = bin_pkgs[0].toLowerCase()
                                try
                                {
                                    if (GITUSER == "a.shaldybin" && tag.contains("-RC") || GITUSER == "v.chemizov" && tag.contains("-RC") || SOURCE.isEmpty() == false)
                                    {
                                        sh """set +x && curl -n --upload-file ./${bin_pkgs} ${url_nexus}/${REPOSITORY}/${letter}/ 2>/dev/null"""    
                                    }
                                    else
                                    {
                                        sh """set +x && curl -n --upload-file ./${bin_pkgs} https://nexus.draszi.fintech.ru/repository/devolopment-dump/${GITUSER}/${OS}/ 2>/dev/null"""
                                    }
                                }
                                catch(err)
                                {
                                    sh """set +x && curl -n --upload-file ./${bin_pkgs} ${url_nexus}/${REPOSITORY}/${letter}/ 2>/dev/null"""
                                }    
                            } 
                            for (bin_pkgs in list_binar)
                            {
                                letter = bin_pkgs[0].toLowerCase()
                                try
                                {
                                    if (GITUSER == "a.shaldybin" && tag.contains("-RC") || GITUSER == "v.chemizov" && tag.contains("-RC") || SOURCE.isEmpty() == false)
                                    {
                                        link="${url_nexus}/${REPOSITORY}/${letter}/${bin_pkgs}"
                                        list_binar_download.add(link)
                                    }
                                    else
                                    {
                                        link="https://nexus.draszi.fintech.ru/repository/devolopment-dump/${GITUSER}/${OS}/${bin_pkgs}"
                                        list_binar_download.add(link)
                                    }
                                }
                                catch(err)
                                {
                                    link="${url_nexus}/${REPOSITORY}/${letter}/${bin_pkgs}"
                                    list_binar_download.add(link)
                                }
                            }
                        }    
                    }
                    println("-"*140 + "\n" + " Cсылки на скачивание собранных debug пакетов " + "\n" + "-"*140)
                    println(list_debug_download.join("\n"))
                    println("-"*140 + "\n" + "-"*140)
                    println("-"*140 + "\n" + " Cсылки на скачивание собранных пакетов " + "\n" + "-"*140)
                    println(list_binar_download.join("\n"))
                    println("-"*140 + "\n" + "-"*140)

                    dir("${result_dir}")
                    {
                        letter = PROJECT[0].toLowerCase()
                        bn = env.BUILD_ID
                        NAME_REPORT = NAME_SRC + '-bn' + bn + '.tar.gz' 
                        sh """ shopt -s extglob
                               rm -rf !(${NAME_SRC}.tar.gz) 
                               tar -xf ./${NAME_SRC}.tar.gz
                               rm -rf ./logs/{light_strace.log,strace.log,irclog.css,light_strace.gz} || True
                               rm -rf ./build/ || True
                               rm -rf ./temporary/{src_original_prepared.tar.gz,py-parce1.log,calls_all.txt,sources_in_spec} || True
                               tar --exclude=${NAME_SRC}.tar.gz -cf ${NAME_REPORT} ./ """
                        println("*"*20 + " загружаю артефакты сборки в репозиторий >>> "+ NAME_REPORT +" " + "*"*20)
                        sh """curl -n --upload-file ./${NAME_REPORT} https://nexus.draszi.fintech.ru/repository/report/sintezm-`echo ${OS} | cut -c3-`/${REPOSITORY}/${letter}/ 2>/dev/null"""
                        println("-"*140 + "\n" + " Cсылки на скачивание архива с результатами чистки " + "\n" + "-"*140)
                        println ("Cкачать пакет >>> " + "https://nexus.draszi.fintech.ru/repository/report/sintezm-" + OS[-3..-1] + "/${REPOSITORY}/${letter}/${NAME_REPORT}")
                        println("-"*140 + "\n" + "-"*140)
                    }
                }
                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
                //+++++++++++++++++ загрузка результатов сборки в mock +++++++++++++++++//
                //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
                else
                {
                    List list_binar = sh(returnStdout: true, script:"""set +x \n echo `find /home/jenkins/workspace/${JOB_NAME}/${result_dir}/fold_binar/ -name "*.rpm" | cut -d '/' -f10-`""").trim().split(' ');
                    println(" В репозиторий я загружу следующие пакеты " + "\n" + list_binar.join("\n"))
                    for (b in list_binar)
                    {
                        letter = b[0].toLowerCase()
                        try
                        {
                            if (GITUSER == "a.shaldybin" && tag.contains("-RC") || GITUSER == "v.chemizov" && tag.contains("-RC") || SOURCE.isEmpty() == false)
                            {
                                sh """set +x && curl -n --upload-file /home/jenkins/workspace/${JOB_NAME}/${result_dir}/fold_binar/${b} https://nexus.draszi.fintech.ru/repository/sintezm/${OS}/platform/${REPOSITORY}/${letter}/ 2>/dev/null"""    
                            }
                            else
                            {
                                sh """set +x && curl -n --upload-file /home/jenkins/workspace/${JOB_NAME}/${result_dir}/fold_binar/${b} https://nexus.draszi.fintech.ru/repository/devolopment-dump/${GITUSER}/${OS}/ 2>/dev/null"""
                            }
                        }
                        catch(err)
                        {
                            sh """set +x && curl -n --upload-file /home/jenkins/workspace/${JOB_NAME}/${result_dir}/fold_binar/${b} https://nexus.draszi.fintech.ru/repository/sintezm/${OS}/platform/${REPOSITORY}/${letter}/ 2>/dev/null"""
                        }
                    }
                    println("-"*140 + "\n" + " Cсылки на скачивание собранных пакетов " + "\n" + "-"*140)
                    for (name_pkgs in list_binar)
                    {
                        nexus = "https://nexus.draszi.fintech.ru/repository"
                        letter = name_pkgs[0].toLowerCase()
                        try
                        {
                            if (GITUSER == "a.shaldybin" && tag.contains("-RC") || GITUSER == "v.chemizov" && tag.contains("-RC") || SOURCE.isEmpty() == false)
                            {
                                println ("Cкачать пакет >>> " + "${nexus}/sintezm/${OS}/platform/${REPOSITORY}/${letter}/${name_pkgs}")
                            }
                            else
                            {
                                println ("Cкачать пакет >>> " + "${nexus}/devolopment-dump/${GITUSER}/${OS}/${name_pkgs}")
                            }
                        }
                        catch(err)
                        {
                            println ("Cкачать пакет >>> " + "${nexus}/sintezm/${OS}/platform/${REPOSITORY}/${letter}/${name_pkgs}")
                        }
                    }
                    println("-"*140 + "\n" + "-"*140)
                    List list_debug = sh(returnStdout: true, script:"""set +x \n echo `find /home/jenkins/workspace/${JOB_NAME}/${result_dir}/fold_debug/ -name "*.rpm" | cut -d '/' -f10-`""").trim().split(' ');
                    if (list_debug[0].isEmpty())
                    {
                        println("---------- из исходных кодов не собралось ни одного debug пакета ----------");
                    }
                    else
                    {
                        println(" В debug репозиторий я загружу следующие пакеты " + "\n" + list_debug.join("\n"));
                        for (d in list_debug)
                        {
                            letter = d[0].toLowerCase()
                            try
                            {
                                if (GITUSER == "a.shaldybin" && tag.contains("-RC") || GITUSER == "v.chemizov" && tag.contains("-RC") || SOURCE.isEmpty() == false)
                                {
                                    sh """set +x && curl -n --upload-file /home/jenkins/workspace/${JOB_NAME}/${result_dir}/fold_debug/${d} https://nexus.draszi.fintech.ru/repository/sintezm/${OS}/debug-platform/${REPOSITORY}/${letter}/ 2>/dev/null """
                                }
                                else
                                {
                                    sh """set +x && curl -n --upload-file /home/jenkins/workspace/${JOB_NAME}/${result_dir}/fold_debug/${d} https://nexus.draszi.fintech.ru/repository/devolopment-dump/${GITUSER}/${OS}/ 2>/dev/null"""
                                }
                            }
                            catch(err)
                            {
                                sh """set +x && curl --user -n --upload-file /home/jenkins/workspace/${JOB_NAME}/${result_dir}/fold_debug/${d} https://nexus.draszi.fintech.ru/repository/sintezm/${OS}/debug-platform/${REPOSITORY}/${letter}/ 2>/dev/null """
                            } 
                        }
                        println("-"*140 + "\n" + " Cсылки на скачивание собранных debug пакетов " + "\n" + "-"*140)
                        for (name_pkgs in list_debug)
                        {
                            nexus = "https://nexus.draszi.fintech.ru/repository"
                            letter = name_pkgs[0].toLowerCase()
                            try
                            {
                                if (GITUSER == "a.shaldybin" && tag.contains("-RC") || GITUSER == "v.chemizov" && tag.contains("-RC") || SOURCE.isEmpty() == false)
                                {
                                    println ("Cкачать пакет >>> " + "${nexus}/sintezm/${OS}/debug-platform/${REPOSITORY}/${letter}/${name_pkgs}")
                                }
                                else
                                {
                                    println ("Cкачать пакет >>> " + "${nexus}/devolopment-dump/${GITUSER}/${OS}/${name_pkgs}")
                                }
                            }
                            catch(err)
                            {
                            println ("Cкачать пакет >>> " + "${nexus}/sintezm/${OS}/debug-platform/${REPOSITORY}/${letter}/${name_pkgs}")
                            }
                        }
                        println("-"*140 + "\n" + "-"*140) 
                    }
                }
            }
            //sh """rm -rf /home/jenkins/.netrc"""
        }
    }
//###########################################################################//
//############### очистки chroot и формирования ссылок на log ###############//
//###########################################################################//
    stage ("""cleaning workspace after build""")
    {
        try
        {
            println("-"*140 + "\n" + " log-и сборки пакета " + "\n" + "-"*140)
            sh """sudo chown -R jenkins:jenkins /home/jenkins/workspace/${JOB_NAME} || true"""
            if (BUILD_WITH_CLEANING.toBoolean())
            {
                sh """ set +x
                       cd ${result_dir}
                       shopt -s extglob
                       echo ${NAME_SRC}
                       rm -rf !(${NAME_SRC}.tar.gz)
                       tar -xf ${NAME_SRC}.tar.gz
                       rm -rf !(logs|temporary)
                       rm -rf ./logs/{light_strace.log,strace.log,irclog.css,light_strace.gz} || True
                       rm -rf ./temporary/{src_original_prepared.tar.gz,py-parce1.log,calls_all.txt,sources_in_spec} || True
                       cd -
                       cp ${PROJECT}.cfg ${result_dir}/logs
                       cp *.log ${result_dir}/logs
                       find ${result_dir}/ -name "*.log" -exec irclog2html {} -s simplett ";"
                       find ${result_dir}/ -name "*.txt" -exec irclog2html {} -s simplett ";"
                       find ${result_dir}/ -name "*.spec" -exec irclog2html {} -s simplett ";"
                       ssh root@10.128.128.124 'mkdir -p /logserver/${JOB_NAME}/${build_number}/cleaning_logs'
                       find ${result_dir}/logs ${result_dir}/temporary -maxdepth 1 -name "*.html" -exec scp {} root@10.128.128.124:/logserver/${JOB_NAME}/${build_number}/cleaning_logs ";" """
                List list_cleaning_logs = sh(returnStdout: true, script:""" set +x \n echo `find ${result_dir} -name "*.html" | rev | cut -d "/" -f-1 | rev` """).trim().split(' ');
                for (a in list_cleaning_logs)
                {
                println("Ссылка на лог >>> http://logserver.draszi.fintech.ru/${JOB_NAME}/${build_number}/cleaning_logs/${a} ")
                }
            }
            else
            {
                sh """ set +x
                       find ${result_dir}/ -name "*.log" -exec irclog2html {} -s simplett ";" 2>/dev/null
                       find ${result_dir}/ -name "*.log.html" -exec scp {} root@10.128.128.124:/logserver/${JOB_NAME}/${build_number}/ ";" 2>/dev/null """
                List list_log = sh(returnStdout: true, script:""" set +x \n echo `ls ${result_dir}/*.log.html | cut -d "/" -f2-` """).trim().split(' ');
                for (a in list_log)
                {
                    println("Ссылка на лог >>> http://logserver.draszi.fintech.ru/${JOB_NAME}/${build_number}/${a} ")
                }
            }
            println("-"*140 + "\n" + " конец log-ов сборки пакета " + "\n" + "-"*140)
            sh """rm -rf ${result_dir}/*log.html""" 
        }
        catch(err)
        {
            sh """ set +x
                   echo 'error section'
                   find ./result/ -maxdepth 1 -name "*.log" -exec irclog2html {} -s simplett ";"
                   find ./result/ -maxdepth 1 -name "*.log.html" -exec scp {} root@10.128.128.124:/logserver/${JOB_NAME}/${build_number}/ ";" """
            List list_log = sh(returnStdout: true, script:""" set +x \n echo `basename -a ./result/*.log.html` """).trim().split(' ');
            println("-"*140 + "\n" + " log-и сборки src пакета " + "\n" + "-"*140)
            for (a in list_log)
            {
                println("Ссылка на лог >>> http://logserver.draszi.fintech.ru/${JOB_NAME}/${build_number}/${a} ")
            }
            println("-"*140 + "\n" + " конец log-ов сборки пакета " + "\n" + "-"*140)
            sh """ rm -rf ./*log.html """
        }
        if (DONT_CLEAN_CHROOT.toBoolean())
        {
            println("Chroot не очищен находится по пути /home/jenkins/chroots/${OS}/${PROJECT}/root/ ")
        }
        else
        {
            sh """rm -rdf /home/jenkins/workspace/${JOB_NAME}/.* | true
                  rm -rdf /home/jenkins/workspace/${JOB_NAME}/* | true
                  sudo rm -rdf /var/lib/mock/${PROJECT}_${OS}
                  sudo rm -rdf /var/lib/mock/${PROJECT}_${OS}-bootstrap 
                  sudo rm -rdf /var/cache/mock/${PROJECT}_${OS}*
                  sudo rm -rdf /home/jenkins/params-build/${JOB_NAME} | true """
            if (SVACE.toBoolean())
            {
                sh """rm -rdf /home/jenkins/svace-results/${PROJECT}"""
            }
            if (BUILD_WITH_CLEANING.toBoolean())
            {
            sh """sudo rm -rf /root/Report/${PROJECT}* | true
                  rm -rf /home/jenkins/Report/${PROJECT}* | true
                  rm -rf /home/jenkins/workspace/${JOB_NAME}/* | true
                  sudo rm -rf /var/lib/mock/${PROJECT}_${OS} 
                  sudo rm -rf /var/lib/mock/${PROJECT}_${OS}-bootstrap  
                  sudo rm -rf /var/cache/mock/${PROJECT}_${OS}*"""
            }
        }
    }
    if (currentBuild.currentResult == "SUCCESS")
    {
        updateGitlabCommitStatus name: 'build', state: 'success'
    }
    else if (currentBuild.currentResult == "ABORTED")
    {
        updateGitlabCommitStatus name: 'build', state: 'canceled'
    }
    else
    {
        updateGitlabCommitStatus name: 'build', state: 'failed'
    } 
}
